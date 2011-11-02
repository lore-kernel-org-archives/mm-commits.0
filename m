From: akpm@linux-foundation.org
Subject: [folded] sysctl-add-support-for-poll-fix.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:18:22 -0700
Message-ID: <201111022018.pA2KIMNS012495@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1KBUSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org, lucas.demarchi@profusion.mobi, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-add-support-for-poll-fix
has been removed from the -mm tree.  Its filename was
     sysctl-add-support-for-poll-fix.patch

This patch was dropped because it was folded into sysctl-add-support-for-poll.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-add-support-for-poll-fix

s/declare/define/ for definitions

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h  |    2 +-
 kernel/utsname_sysctl.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-add-support-for-poll-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-support-for-poll-fix
+++ a/include/linux/sysctl.h
@@ -1029,7 +1029,7 @@ void proc_sys_poll_notify(struct ctl_tab
 	.event = ATOMIC_INIT(0),					\
 	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
 
-#define DECLARE_CTL_TABLE_POLL(name)					\
+#define DEFINE_CTL_TABLE_POLL(name)					\
 	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
 
 /* A sysctl table is an array of struct ctl_table: */
diff -puN kernel/utsname_sysctl.c~sysctl-add-support-for-poll-fix kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-add-support-for-poll-fix
+++ a/kernel/utsname_sysctl.c
@@ -62,8 +62,8 @@ static int proc_do_uts_string(ctl_table 
 #define proc_do_uts_string NULL
 #endif
 
-static DECLARE_CTL_TABLE_POLL(hostname_poll);
-static DECLARE_CTL_TABLE_POLL(domainname_poll);
+static DEFINE_CTL_TABLE_POLL(hostname_poll);
+static DEFINE_CTL_TABLE_POLL(domainname_poll);
 
 static struct ctl_table uts_kern_table[] = {
 	{
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctl-add-support-for-poll.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch

