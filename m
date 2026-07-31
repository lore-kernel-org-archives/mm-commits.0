Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52D133A014
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465841; cv=none; b=kIkNczSGohdhD6BVR5tYTFuIVoBWTqdx6EY9KLjWfCyC7Fp9eNHZgi75x5O6nlOWe9g8QdllMVyRblIzUi/SqSfJ3BWgnaxs4xi9w8RuEtkEPf/5AprfyHIZUFKSp4kTUzRykc1pm3QrecUx8HlLquNWLbczszDv8RAme/gvhoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465841; c=relaxed/simple;
	bh=HOBxMhhTnqLwpwIPfzDRBIfjq5DLmz/llylxYRlzg6Q=;
	h=Date:To:From:Subject:Message-Id; b=DhHRHnrpAVBksdfkqBWLdz4gq5BE6pdO91WbTIsT4d2nN+jHfCFE+EpJzCm7ISPEMh8QoP125+PyzL1eY9XB5M0i+we3EXio5byl5gdEWNQ9n9hfCH+I44PHaZ/rikFYvrHcltKyJUIS80qlGNInxbh2eww6QWh5+9mqFEuQ1rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y0BWxY95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y0BWxY95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4CD1F000E9;
	Fri, 31 Jul 2026 02:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465839;
	bh=CtnptkMyc1k5SJ2vAGs1Lcx4u0x0TQPK6M0GJPZd93E=;
	h=Date:To:From:Subject;
	b=y0BWxY95WmL+Q1cLVM08NlJ4Jcb2Ch//YHBOOyMCrYpHCXkwB+TsHr2Mtsv2cq23k
	 RFYadslcwP8crfZSSbMp+4LcgyiixH+hfmptofgLuf7zGYY6d5YLVilnAsrJxmmvHu
	 wRe2jiS59itqt2EJ2Gi4M2l4gCJxdKgCedeKrGVg=
Date: Thu, 30 Jul 2026 19:43:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-free-per-record-allocations.patch removed from -mm tree
Message-Id: <20260731024359.BB4CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: free per-record allocations
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-free-per-record-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
hugetlb-evaluate-subpool-free-state-while-locked.patch
fat-release-buffer-head-after-rebuilding-parent.patch

