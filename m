From: akpm@linux-foundation.org
Subject: + bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:02:42 -0700
Message-ID: <200803212202.m2LM2gUr012595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbYCUWGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth: replace deprecated RW_LOCK_UNLOCKED macros
has been added to the -mm tree.  Its filename is
     bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: replace deprecated RW_LOCK_UNLOCKED macros
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

The older RW_LOCK_UNLOCKED macros defeat lockdep state tracing so replace them
with the newer __RW_LOCK_UNLOCKED macros.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_sock.c    |    2 +-
 net/bluetooth/l2cap.c       |    2 +-
 net/bluetooth/rfcomm/sock.c |    2 +-
 net/bluetooth/sco.c         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN net/bluetooth/hci_sock.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros
+++ a/net/bluetooth/hci_sock.c
@@ -84,7 +84,7 @@ static struct hci_sec_filter hci_sec_fil
 };
 
 static struct bt_sock_list hci_sk_list = {
-	.lock = RW_LOCK_UNLOCKED
+	.lock = __RW_LOCK_UNLOCKED(hci_sk_list.lock)
 };
 
 /* Send frame to RAW socket */
diff -puN net/bluetooth/l2cap.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros net/bluetooth/l2cap.c
--- a/net/bluetooth/l2cap.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros
+++ a/net/bluetooth/l2cap.c
@@ -62,7 +62,7 @@ static u32 l2cap_feat_mask = 0x0000;
 static const struct proto_ops l2cap_sock_ops;
 
 static struct bt_sock_list l2cap_sk_list = {
-	.lock = RW_LOCK_UNLOCKED
+	.lock = __RW_LOCK_UNLOCKED(l2cap_sk_list.lock)
 };
 
 static void __l2cap_sock_close(struct sock *sk, int reason);
diff -puN net/bluetooth/rfcomm/sock.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros net/bluetooth/rfcomm/sock.c
--- a/net/bluetooth/rfcomm/sock.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros
+++ a/net/bluetooth/rfcomm/sock.c
@@ -60,7 +60,7 @@
 static const struct proto_ops rfcomm_sock_ops;
 
 static struct bt_sock_list rfcomm_sk_list = {
-	.lock = RW_LOCK_UNLOCKED
+	.lock = __RW_LOCK_UNLOCKED(rfcomm_sk_list.lock)
 };
 
 static void rfcomm_sock_close(struct sock *sk);
diff -puN net/bluetooth/sco.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros net/bluetooth/sco.c
--- a/net/bluetooth/sco.c~bluetooth-replace-deprecated-rw_lock_unlocked-macros
+++ a/net/bluetooth/sco.c
@@ -58,7 +58,7 @@
 static const struct proto_ops sco_sock_ops;
 
 static struct bt_sock_list sco_sk_list = {
-	.lock = RW_LOCK_UNLOCKED
+	.lock = __RW_LOCK_UNLOCKED(sco_sk_list.lock)
 };
 
 static void __sco_chan_add(struct sco_conn *conn, struct sock *sk, struct sock *parent);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

