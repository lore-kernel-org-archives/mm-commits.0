Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE83F4409
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 20:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760646855; cv=none; b=Rf+NMiHi5TAOn4/Me5FWEo3RbFpHnNQXgnpqlkjpetZT9yy5hy65pIwNMI+D7xegSAX7Hg77Y89H4jUnZWbY2wCmdjL+m5TtnXkmAGC0KrIWHCmWoDvynKEATbvy53SJk+YdyFfx5r9r+eyvx5OuQHYLtGPjtAz6dtaCbVw8pT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760646855; c=relaxed/simple;
	bh=CR8xHI6Cuz7TW9OhEsBS4Rgz/86iA6XUgvO0FieLSRs=;
	h=Date:To:From:Subject:Message-Id; b=GVIKHh2FGtouzwMT8TYyXGU/cd/e4daNJHPN1vfhRz+aPgqTzZcyraEf9Dul4JtNZF5Sj0YHvN9+JIwBjnp/y/cpzcqeDwIlSXj60WRo+srPCE4t0RFC1h15wul0nwPxUqtqiVl2HebWJ4skRyQVR3y6/PXPJFI4nfh7XX/ig8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j7YkMQuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j7YkMQuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0E3C4CEF1;
	Thu, 16 Oct 2025 20:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760646855;
	bh=CR8xHI6Cuz7TW9OhEsBS4Rgz/86iA6XUgvO0FieLSRs=;
	h=Date:To:From:Subject:From;
	b=j7YkMQuQooNNwbbOPH25hjgxugIneAHINZIvqRcXmA6wrVsyQ1EqVEL6MUEmvOvyp
	 jA6XNwtG4OxowwC4cbTo+IEYWMHCnV5K0YdTrpdQCbKRnp0g6cuJydOD/Xc1Rh0GSo
	 s98jEXfolHP5epiu5D/oIt0EqNMXLFvZY9BbDb6s=
Date: Thu, 16 Oct 2025 13:34:14 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-add-help-option-support.patch added to mm-new branch
Message-Id: <20251016203415.7B0E3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: add help option support
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-add-help-option-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-add-help-option-support.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page_owner_sort: add help option support
Date: Thu, 16 Oct 2025 13:49:25 +0800

Add -h/--help option to display usage information and improve code style.

Link: https://lkml.kernel.org/r/20251016054927.138510-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-add-help-option-support
+++ a/tools/mm/page_owner_sort.c
@@ -667,14 +667,15 @@ int main(int argc, char **argv)
 		{ "pid", required_argument, NULL, 1 },
 		{ "tgid", required_argument, NULL, 2 },
 		{ "name", required_argument, NULL, 3 },
-		{ "cull",  required_argument, NULL, 4 },
-		{ "sort",  required_argument, NULL, 5 },
+		{ "cull", required_argument, NULL, 4 },
+		{ "sort", required_argument, NULL, 5 },
+		{ "help", no_argument, NULL, 'h' },
 		{ 0, 0, 0, 0},
 	};
 
 	compare_flag = COMP_NO_FLAG;
 
-	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "admnpstPh", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			compare_flag |= COMP_ALLOC;
@@ -700,6 +701,9 @@ int main(int argc, char **argv)
 		case 'n':
 			compare_flag |= COMP_COMM;
 			break;
+		case 'h':
+			usage();
+			exit(0);
 		case 1:
 			filter = filter | FILTER_PID;
 			fc.pids = parse_nums_list(optarg, &fc.pids_size);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-use-stdboolh-in-page_owner_sortc.patch
tools-mm-page_owner_sort-add-help-option-support.patch

