From: akpm@linux-foundation.org
Subject: + init-mainc-make-local-symbol-static.patch added to -mm tree
Date: Thu, 18 Jan 2018 14:11:28 -0800
Message-ID: <5a611b90.bbnpfWJ63M0r6hVd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeARWL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 17:11:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisadr@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: make local symbol static
has been added to the -mm tree.  Its filename is
     init-mainc-make-local-symbol-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-make-local-symbol-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-make-local-symbol-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christopher Díaz Riveros <chrisadr@gentoo.org>
Subject: init/main.c: make local symbol static

Fixes the following sparse warning:

init/main.c:167:12: warning:
  symbol 'envp_init' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20180118220629.25116-1-chrisadr@gentoo.org
Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-make-local-symbol-static init/main.c
--- a/init/main.c~init-mainc-make-local-symbol-static
+++ a/init/main.c
@@ -164,7 +164,7 @@ static int __init set_reset_devices(char
 __setup("reset_devices", set_reset_devices);
 
 static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
_

Patches currently in -mm which might be from chrisadr@gentoo.org are

init-mainc-make-local-symbol-static.patch

