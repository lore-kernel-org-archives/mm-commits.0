Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B561EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119302; cv=none; b=kfIlQsITurH3I085ez0HbmD4f2TbgBhIGJb9AhvDaMxZsRk1aVjVCMvpKvJLVEWuD3zRcU8R3ULOIDZEIY4vbdqQTFeiQZb7xIfiKQt2OSq4dq/4aY+b4jOVHMFtSfbErvU3LgS4TrdwvoFLWHH2J7XVZ5yu/YTGj1cnKAcA8Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119302; c=relaxed/simple;
	bh=EjkDKzMP8qiW6gVqn4ZcEY5Cf7GDQkessaK2W0W4QHM=;
	h=Date:To:From:Subject:Message-Id; b=EgPcOvcHbwvXfAHFsB7qIbJ9HX2PZnFBU2gR4JBbHlr5etDRXTeiwB75wc/n+2e4yJvxomPr9PmA/j9IHOmX1n4r036Viqm1wtLiX3pkNVDBDdtvEUOWkVATJsXi1rGbuoammyMNMMMOMOWa2n9jCQnY/Ep48wLtL/xiGbD5DUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pgAqFs0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pgAqFs0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE64EC4CEE4;
	Tue, 13 May 2025 06:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119302;
	bh=EjkDKzMP8qiW6gVqn4ZcEY5Cf7GDQkessaK2W0W4QHM=;
	h=Date:To:From:Subject:From;
	b=pgAqFs0Cz5rRZuGqy4bAAfEcKFVCmjrKzXiAzYgjvl/kvJPupzOxHJ1Y8I1XEmgib
	 L+AgSV+Ewey44I+VjU22qeEffkeJj4mojcuF4vRuDq0GvMQQFRuZN7aDbCGPDXoNrl
	 IOTYzSkWz8nLe+Tf93b+GSz/l5q7IW/uJTvFZ0KA=
Date: Mon, 12 May 2025 23:55:01 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-drop-kmemleak_warning-variable.patch removed from -mm tree
Message-Id: <20250513065501.EE64EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: drop kmemleak_warning variable
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-drop-kmemleak_warning-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: kmemleak: drop kmemleak_warning variable
Date: Wed, 30 Apr 2025 16:59:45 -0400

These are a trivial mm/kmemleak.c cleanups.  I found these while reading
through the code.


This patch (of 3):

The kmemleak_warning variable is not used since commit c5665868183f ("mm:
kmemleak: use the memory pool for early allocations"), drop it.

Link: https://lkml.kernel.org/r/cover.1746046744.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/97e23faa7b67099027a1094c9438da5f72e037af.1746046744.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-drop-kmemleak_warning-variable
+++ a/mm/kmemleak.c
@@ -215,8 +215,6 @@ static int kmemleak_enabled = 1;
 static int kmemleak_free_enabled = 1;
 /* set in the late_initcall if there were no errors */
 static int kmemleak_late_initialized;
-/* set if a kmemleak warning was issued */
-static int kmemleak_warning;
 /* set if a fatal kmemleak error has occurred */
 static int kmemleak_error;
 
@@ -254,7 +252,6 @@ static void kmemleak_disable(void);
 #define kmemleak_warn(x...)	do {		\
 	pr_warn(x);				\
 	dump_stack();				\
-	kmemleak_warning = 1;			\
 } while (0)
 
 /*
_

Patches currently in -mm which might be from luizcap@redhat.com are


