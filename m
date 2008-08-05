From: akpm@linux-foundation.org
Subject: + drivers-firmware-iscsi_ibftc-make-3-functions-static.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:20:59 -0700
Message-ID: <200808052020.m75KKxT4021546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761002AbYHEUVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/firmware/iscsi_ibft.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     drivers-firmware-iscsi_ibftc-make-3-functions-static.patch

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
Subject: drivers/firmware/iscsi_ibft.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- ibft_attr_show_initiator()
- ibft_attr_show_nic()
- ibft_attr_show_target()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-make-3-functions-static drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~drivers-firmware-iscsi_ibftc-make-3-functions-static
+++ a/drivers/firmware/iscsi_ibft.c
@@ -334,9 +334,9 @@ static void ibft_release(struct kobject 
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
+					struct ibft_attribute *attr,
+					char *buf)
 {
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
@@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct 
 	return str - buf;
 }
 
-ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-			    struct ibft_attribute *attr,
-			    char *buf)
+static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
+				  struct ibft_attribute *attr,
+				  char *buf)
 {
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
@@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_k
 	return str - buf;
 };
 
-ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-			       struct ibft_attribute *attr,
-			       char *buf)
+static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
+				     struct ibft_attribute *attr,
+				     char *buf)
 {
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm_initc-avoid-ifdef-inside-macro-expansion.patch
feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch

