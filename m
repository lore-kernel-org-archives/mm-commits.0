Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8312033689E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708107; cv=none; b=KNp40UrnJadP/pI39ewO2W19CjTqGDaSfxzdxB1gor9ECEIjBi8MA7DEmeKkVy5q9eugUEHAH+IDv2Al5dvezkqyUZwLree1H5/n1onuTKgN6FG7DtTaIvlnrmLZF1au5I0qvCHQ/p+VupoEDMs0SZ1svCS5qKegm2srHKwTTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708107; c=relaxed/simple;
	bh=Ay4vSVfiZIhgG62LuPEtA6EUzOh2B8mtQ2j8jXxvnXg=;
	h=Date:To:From:Subject:Message-Id; b=mjEM7QRyj/UmhfdLgzSyJQ0QR6i/h8kE8VBtlOY+544nuUF/2FrwV2wWe4OvqUOKUZpUUunRJJ/o1HOPAOhRANOSF9trugIV6d7D+RoO3yVrGUKZnQagnAQILHyz+DXE/mznme0X1DZ9gKpUEaYhxSh6wp34jkqGDntbQGyZ28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w7Xd4zmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w7Xd4zmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F751F000E9;
	Mon, 29 Jun 2026 04:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708106;
	bh=KAq5UbbetlGnPkwFfTm/bH2KkIRfutPsRb59yEXeLz8=;
	h=Date:To:From:Subject;
	b=w7Xd4zmc6JF3wp4NdLgwJtXDuWnqji0pycXuhDDwndo//acNwKxAe764/GKSWL0NV
	 MxMfKeXg9lMHnevpfombA4Mi80LNp5RykJ70TbF7yj87RDHvCSsglwpz2Z0EovmobO
	 MSxc2y4Sbf16NAw7Fwsn4Jo16HiVCUP2jYSIbdag=
Date: Sun, 28 Jun 2026 21:41:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-free-per-record-allocations.patch added to mm-new branch
Message-Id: <20260629044146.10F751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: free per-record allocations
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/mm/page_owner_sort: free per-record allocations
Date: Mon, 29 Jun 2026 09:43:15 +0800

add_list() allocates comm and txt for each page owner record, but the
cleanup path only frees the outer list array.  This leaks both buffers for
every retained record.

Free partial allocations in add_list(), discarded records during culling,
and retained records on exit.

Link: https://lore.kernel.org/20260629014316.130307-3-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-free-per-record-allocations
+++ a/tools/mm/page_owner_sort.c
@@ -396,6 +396,12 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static void free_block_list(struct block_list *block)
+{
+	free(block->comm);
+	free(block->txt);
+}
+
 static int get_arg_type(const char *arg)
 {
 	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
@@ -502,9 +508,14 @@ static bool add_list(char *buf, int len,
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
-	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	list[list_size].txt = malloc(len + 1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -863,8 +874,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -898,8 +911,11 @@ out_free:
 		free(ext_buf);
 	if (buf)
 		free(buf);
-	if (list)
+	if (list) {
+		for (i = 0; i < list_size; i++)
+			free_block_list(&list[i]);
 		free(list);
+	}
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

