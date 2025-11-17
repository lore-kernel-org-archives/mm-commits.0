Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA15212557
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343150; cv=none; b=PQe0RsRm6w+PYiuzK7a1D+OPjQuEQeaSu7aAQP9mgCt/EVoCy3QByXln0jVGlQKKOc0zAAtNC2hgbqT1XVz9oeaBfT9ROcp+V4VbWi95akQFpV0Xx0Kq3qhEJdU37c6K1zIZ091g6q9DwpiQmV8KH4zoq8FtafXiOl0vNreA3NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343150; c=relaxed/simple;
	bh=AndMmSGoiqsv3q2YFBmMW47VqkT3xS9pYpNH44BWsKc=;
	h=Date:To:From:Subject:Message-Id; b=lZJUQcDoV+R1Pi9WWuqjNrX0Zk7/eVEIybG3Qb5VlybSp+Ew/lDbQiUEs/YLcVkv8YGg5+uRrygt83/D7ztQWetKqQB6jpnNFg/bxF7RE0t2SAzOxrNmifyRvBo/8KPhHwIW8G83kZlk8Fj6//4Mvb7Tw2X4QJz5Ir/AzLDSSn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v9FrvBbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v9FrvBbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34348C19423;
	Mon, 17 Nov 2025 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343150;
	bh=AndMmSGoiqsv3q2YFBmMW47VqkT3xS9pYpNH44BWsKc=;
	h=Date:To:From:Subject:From;
	b=v9FrvBbOh0tjJEjyudtItDFK/PU9PXWgZ0jv+sPGA7eDUp8ijDIuAD8KRKb5JYPKF
	 IThq7fcSMGCyci/z9/QLzov3HF2W3TwIqe9M8q8jsPNK38vJcBG/QJg/65hnoA2Hae
	 itEaugI39XpXothk2quUAguiRCJTvaaOfviLWxpU=
Date: Sun, 16 Nov 2025 17:32:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-add-help-option-support.patch removed from -mm tree
Message-Id: <20251117013230.34348C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: add help option support
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-add-help-option-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page_owner_sort: add help option support
Date: Thu, 16 Oct 2025 13:49:25 +0800

Add -h/--help option to display usage information and improve code style.

Link: https://lkml.kernel.org/r/20251016054927.138510-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>
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


