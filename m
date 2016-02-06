From: akpm@linux-foundation.org
Subject: + param-convert-some-on-off-users-to-strtobool-fix.patch added to -mm tree
Date: Fri, 05 Feb 2016 17:58:01 -0800
Message-ID: <56b55329.rPMSfrk7qc1pQvxg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbcBFB6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 20:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: param-convert-some-on-off-users-to-strtobool fix
has been added to the -mm tree.  Its filename is
     param-convert-some-on-off-users-to-strtobool-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/param-convert-some-on-off-users-to-strtobool-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/param-convert-some-on-off-users-to-strtobool-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: param-convert-some-on-off-users-to-strtobool fix

This converts a missed __setup return (and silences the build warning it
was causing).

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtasd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool-fix arch/powerpc/kernel/rtasd.c
--- a/arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool-fix
+++ a/arch/powerpc/kernel/rtasd.c
@@ -592,8 +592,6 @@ __setup("surveillance=", surveillance_se
 
 static int __init rtasmsgs_setup(char *str)
 {
-	kstrtobool(str, &full_rtas_msgs);
