Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C0352F83
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967410; cv=none; b=Dj7UeqeRm0h2vJ/bum0YcrouHsQOZKVHj6DcgaRiYjDwR2RkQUnKWT7UpegVfjPFFs+OJfGYk2dEjm4uXYnlwh3QUcSzquvxxzs7jwZa9zLcBbDiYE//GG+tX4gV0CXqSl8BaeDj1Tv1+8wIIGdmth1Ktn/TbEmwV6m4GcchLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967410; c=relaxed/simple;
	bh=4StChh1hJFdAr6R4uIQ2ZvkTE92oOOlw1uLbiIVashY=;
	h=Date:To:From:Subject:Message-Id; b=u73mayREuJBxHHZMbuc1WLm3rsW3b8fMw5XaifgrYRMQtSvCNgx4KjtK7H42icljn4sUkCi4Keakfs0P79w8WYvoGTlK0OGCDi4WHoJSx5SQAfTtFIgoK33BQJ4y45/E80ge9Hxvg7WEVemSePN8Cat2QaT+PwIS/6UVho7BRew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mXnJIN2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mXnJIN2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ECEC116D0;
	Wed, 21 Jan 2026 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967409;
	bh=4StChh1hJFdAr6R4uIQ2ZvkTE92oOOlw1uLbiIVashY=;
	h=Date:To:From:Subject:From;
	b=mXnJIN2/l/YNWW6eK0jYN1jzUxgoF5EG7zsh8kOFJ6In/lrQjTHNir+EdmhJ9aVjd
	 z1JB9lU/7S2sbXztLTJafwsmTOtU7IUt/rniYRYHZtdoLTwdrUuG0w03Whm4G5OuPt
	 1CVxQsJJ7Tvh1D748gKD639w5Q53wtsr5ec5cy18=
Date: Tue, 20 Jan 2026 19:50:09 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@kernel.org,rppt@kernel.org,mingo@kernel.org,link@vivo.com,kernel@pengutronix.de,guoweikang.kernel@gmail.com,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,alexander.shishkin@linux.intel.com,a.fatoum@pengutronix.de,lillian@star-ark.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch removed from -mm tree
Message-Id: <20260121035009.B5ECEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main.c: check if rdinit was explicitly set before printing warning
has been removed from the -mm tree.  Its filename was
     init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lillian Berry <lillian@star-ark.net>
Subject: init/main.c: check if rdinit was explicitly set before printing warning
Date: Sun, 11 Jan 2026 07:56:35 -0500

The rdinit parameter is set by default, and attempted during boot even if
not specified in the command line.  Only print the warning about rdinit
being inaccessible if the rdinit value was found in command line; it's
just noise otherwise.

[akpm@linux-foundation.org: move ramdisk_execute_command_set into __initdata]
Link: https://lkml.kernel.org/r/20260111125635.53682-1-lillian@star-ark.net
Signed-off-by: Lillian Berry <lillian@star-ark.net>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/init/main.c~init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning
+++ a/init/main.c
@@ -162,6 +162,7 @@ static size_t initargs_offs;
 
 static char *execute_command;
 static char *ramdisk_execute_command = "/init";
+static bool __initdata ramdisk_execute_command_set;
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
@@ -623,6 +624,7 @@ static int __init rdinit_setup(char *str
 	unsigned int i;
 
 	ramdisk_execute_command = str;
+	ramdisk_execute_command_set = true;
 	/* See "auto" comment in init_setup */
 	for (i = 1; i < MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
@@ -1699,8 +1701,9 @@ static noinline void __init kernel_init_
 	int ramdisk_command_access;
 	ramdisk_command_access = init_eaccess(ramdisk_execute_command);
 	if (ramdisk_command_access != 0) {
-		pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
-			ramdisk_execute_command, ramdisk_command_access);
+		if (ramdisk_execute_command_set)
+			pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
+				ramdisk_execute_command, ramdisk_command_access);
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
_

Patches currently in -mm which might be from lillian@star-ark.net are


