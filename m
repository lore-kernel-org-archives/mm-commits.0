From: akpm@linux-foundation.org
Subject: + watchdog-fix-watchdog_nmi_enable_all.patch added to -mm tree
Date: Wed, 22 Apr 2015 13:13:11 -0700
Message-ID: <553800d7.ncToV/fE+oIudOg+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326AbbDVUNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: fix watchdog_nmi_enable_all()
has been added to the -mm tree.  Its filename is
     watchdog-fix-watchdog_nmi_enable_all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-fix-watchdog_nmi_enable_all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-fix-watchdog_nmi_enable_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: fix watchdog_nmi_enable_all()

The 'watchdog_user_enabled' variable is only used as an 'interface' to the
/proc/sys/kernel/watchdog parameter.  The actual state of the watchdog is
tracked by bits in the 'watchdog_enabled' variable.  So,
watchdog_nmi_enable_all() should check the NMI_WATCHDOG_ENABLED bit in
'watchdog_enabled'.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-fix-watchdog_nmi_enable_all kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-watchdog_nmi_enable_all
+++ a/kernel/watchdog.c
@@ -608,7 +608,7 @@ void watchdog_nmi_enable_all(void)
 {
 	int cpu;
 
-	if (!watchdog_user_enabled)
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
 		return;
 
 	get_online_cpus();
_

Patches currently in -mm which might be from uobergfe@redhat.com are

origin.patch
watchdog-fix-watchdog_nmi_enable_all.patch
linux-next.patch

