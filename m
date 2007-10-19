From: akpm@linux-foundation.org
Subject: - ipmi-remove-bogus-semaphore-from-watchdog.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:14 -0700
Message-ID: <200710190346.l9J3kE1u013313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXJSDzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: remove bogus semaphore from watchdog
has been removed from the -mm tree.  Its filename was
     ipmi-remove-bogus-semaphore-from-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: remove bogus semaphore from watchdog
From: Corey Minyard <cminyard@mvista.com>

Lockdep was giving an error when loading the IPMI watchdog module.  It turns
out that if you try to claim a lock in a parameter handling routine, lockdep
won't see that lock as "static" yet because the module is not yet on the
module list, so it will complain.

However, the semaphore in question is completely unnecessary.  So just remove
it.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-remove-bogus-semaphore-from-watchdog drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-remove-bogus-semaphore-from-watchdog
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -166,8 +166,6 @@ static char expect_close;
 
 static int ifnum_to_use = -1;
 
-static DECLARE_RWSEM(register_sem);
-
 /* Parameters to ipmi_set_timeout */
 #define IPMI_SET_TIMEOUT_NO_HB			0
 #define IPMI_SET_TIMEOUT_HB_IF_NECESSARY	1
@@ -193,11 +191,9 @@ static int set_param_int(const char *val
 	if (endp == val)
 		return -EINVAL;
 
-	down_read(&register_sem);
 	*((int *)kp->arg) = l;
 	if (watchdog_user)
 		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
-	up_read(&register_sem);
 
 	return rv;
 }
@@ -226,17 +222,15 @@ static int set_param_str(const char *val
 
 	s = strstrip(valcp);
 
-	down_read(&register_sem);
 	rv = fn(s, NULL);
 	if (rv)
-		goto out_unlock;
+		goto out;
 
 	check_parms();
 	if (watchdog_user)
 		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
- out_unlock:
-	up_read(&register_sem);
+ out:
 	return rv;
 }
 
@@ -895,7 +889,6 @@ static void ipmi_register_watchdog(int i
 {
 	int rv = -EBUSY;
 
-	down_write(&register_sem);
 	if (watchdog_user)
 		goto out;
 
@@ -922,8 +915,6 @@ static void ipmi_register_watchdog(int i
 	}
 
  out:
-	up_write(&register_sem);
-
 	if ((start_now) && (rv == 0)) {
 		/* Run from startup, so start the timer now. */
 		start_now = 0; /* Disable this function after first startup. */
@@ -937,8 +928,6 @@ static void ipmi_unregister_watchdog(int
 {
 	int rv;
 
-	down_write(&register_sem);
-
 	if (!watchdog_user)
 		goto out;
 
@@ -963,7 +952,7 @@ static void ipmi_unregister_watchdog(int
 	watchdog_user = NULL;
 
  out:
-	up_write(&register_sem);
+	return;
 }
 
 #ifdef HAVE_NMI_HANDLER
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch
