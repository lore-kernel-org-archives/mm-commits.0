Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BC818872A
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653050; cv=none; b=cWzQTVOv54K91OqdYWnxR3fjhOrTRjpT/60fAY4SRPr0r+DLhUkou0JOEOolo9rcDYUVhWe6040FOilZ57r42g+CLj6qFtAPpH1UewEEE4mKgmcW9vfBR4NiTwb0JC0E2faJUZC6o9cbj9KMlEuu1rBCmjZlx26cJwiAN2wRBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653050; c=relaxed/simple;
	bh=G5B6h05vZwCmmT3ELc2T+CIechkLqRzYGNA994g8Xkw=;
	h=Date:To:From:Subject:Message-Id; b=rmXDSqglva2koxkYSszSKJ213PsBderT92rgwFuxaLkKxgHMGfRP7RK59gT4SVAiB+MYyUYO7wrvsrJ3zomNs5XC5ZgIXpzzuf6D1H+k3/s4G0XJk6cY1HLl5peqPMYwUho7UptJbPvUUBCx4BB2UhxmXj9A0nhw4vV+G75olno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tBtFyHDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tBtFyHDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D015AC4CECF;
	Fri, 15 Nov 2024 06:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653049;
	bh=G5B6h05vZwCmmT3ELc2T+CIechkLqRzYGNA994g8Xkw=;
	h=Date:To:From:Subject:From;
	b=tBtFyHDujlHS7kgy3G0E1XBTYnw1Np0YQ8OfI466D7aujFsGcGbtxgy+3Jrh3Mlx3
	 3NXbTcdbjDkNjXe+sSW+xut50xGGCkImEvHou9hWi/aKZCsQllNTwEvXBp4EZG2Mnf
	 M1jABVPRycPOnSIH/iU/8/Vtxb09D6pVO8G2R4zg=
Date: Thu, 14 Nov 2024 22:44:05 -0800
To: mm-commits@vger.kernel.org,wladislav.kw@gmail.com,vishal.moola@gmail.com,sj@kernel.org,oleksandr@natalenko.name,motiejus@jakstys.lt,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-fix-compile-error.patch removed from -mm tree
Message-Id: <20241115064408.D015AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: fix compile error
has been removed from the -mm tree.  Its filename was
     tools-mm-fix-compile-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Motiejus Jak≈`tys <motiejus@jakstys.lt>
Subject: tools/mm: fix compile error
Date: Tue, 12 Nov 2024 19:16:55 +0200

Add a missing semicolon.

Link: https://lkml.kernel.org/r/20241112171655.1662670-1-motiejus@jakstys.lt
Fixes: ece5897e5a10 ("tools/mm: -Werror fixes in page-types/slabinfo")
Signed-off-by: Motiejus Jak≈`tys <motiejus@jakstys.lt>
Closes: https://github.com/NixOS/nixpkgs/issues/355369
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-fix-compile-error
+++ a/tools/mm/page-types.c
@@ -420,7 +420,7 @@ static void show_page(unsigned long voff
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%" PRIu64 "\t", cgroup)
+		printf("@%" PRIu64 "\t", cgroup);
 	if (opt_list_mapcnt)
 		printf("%" PRIu64 "\t", mapcnt);
 
_

Patches currently in -mm which might be from motiejus@jakstys.lt are


