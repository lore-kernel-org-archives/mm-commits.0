From: akpm@linux-foundation.org
Subject: + x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:41:32 -0800
Message-ID: <200911241941.nAOJfWXl010339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054AbZKXTqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:46:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, mingo@elte.hu, steiner@sgi.com


The patch titled
     x86: uv: xpc needs to provide an abstraction for uv_gpa
has been added to the -mm tree.  Its filename is
     x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: uv: xpc needs to provide an abstraction for uv_gpa
From: Robin Holt <holt@sgi.com>

Provide an SGI SN2/UV agnositic method for converting a global physical
address into a socket physical address.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h      |    1 +
 drivers/misc/sgi-xp/xp_main.c |    3 +++
 drivers/misc/sgi-xp/xp_sn2.c  |   10 ++++++++++
 drivers/misc/sgi-xp/xp_uv.c   |   10 ++++++++++
 4 files changed, 24 insertions(+)

diff -puN drivers/misc/sgi-xp/xp.h~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa
+++ a/drivers/misc/sgi-xp/xp.h
@@ -339,6 +339,7 @@ extern short xp_partition_id;
 extern u8 xp_region_size;
 
 extern unsigned long (*xp_pa) (void *);
+extern unsigned long (*xp_socket_pa) (unsigned long);
 extern enum xp_retval (*xp_remote_memcpy) (unsigned long, const unsigned long,
 		       size_t);
 extern int (*xp_cpu_to_nasid) (int);
diff -puN drivers/misc/sgi-xp/xp_main.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -44,6 +44,9 @@ EXPORT_SYMBOL_GPL(xp_region_size);
 unsigned long (*xp_pa) (void *addr);
 EXPORT_SYMBOL_GPL(xp_pa);
 
+unsigned long (*xp_socket_pa) (unsigned long gpa);
+EXPORT_SYMBOL_GPL(xp_socket_pa);
+
 enum xp_retval (*xp_remote_memcpy) (unsigned long dst_gpa,
 				    const unsigned long src_gpa, size_t len);
 EXPORT_SYMBOL_GPL(xp_remote_memcpy);
diff -puN drivers/misc/sgi-xp/xp_sn2.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa drivers/misc/sgi-xp/xp_sn2.c
--- a/drivers/misc/sgi-xp/xp_sn2.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -84,6 +84,15 @@ xp_pa_sn2(void *addr)
 }
 
 /*
+ * Convert a global physical to a socket physical address.
+ */
+static unsigned long
+xp_socket_pa_sn2(unsigned long gpa)
+{
+	return gpa;
+}
+
+/*
  * Wrapper for bte_copy().
  *
  *	dst_pa - physical address of the destination of the transfer.
@@ -162,6 +171,7 @@ xp_init_sn2(void)
 	xp_region_size = sn_region_size;
 
 	xp_pa = xp_pa_sn2;
+	xp_socket_pa = xp_socket_pa_sn2;
 	xp_remote_memcpy = xp_remote_memcpy_sn2;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
 	xp_expand_memprotect = xp_expand_memprotect_sn2;
diff -puN drivers/misc/sgi-xp/xp_uv.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -32,6 +32,15 @@ xp_pa_uv(void *addr)
 	return uv_gpa(addr);
 }
 
+/*
+ * Convert a global physical to socket physical address.
+ */
+static unsigned long
+xp_socket_pa_uv(unsigned long gpa)
+{
+	return uv_gpa_to_soc_phys_ram(gpa);
+}
+
 static enum xp_retval
 xp_remote_memcpy_uv(unsigned long dst_gpa, const unsigned long src_gpa,
 		    size_t len)
@@ -123,6 +132,7 @@ xp_init_uv(void)
 	xp_region_size = sn_region_size;
 
 	xp_pa = xp_pa_uv;
+	xp_socket_pa = xp_socket_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_uv;
 	xp_expand_memprotect = xp_expand_memprotect_uv;
_

Patches currently in -mm which might be from holt@sgi.com are

x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch

