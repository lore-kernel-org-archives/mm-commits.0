From: akpm@linux-foundation.org
Subject: - apm_eventinfo_t-are-userspace-types.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:24 -0800
Message-ID: <200712202336.lBKNaOWO018801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbXLTXg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajax@redhat.com, mm-commits@vger.kernel.org


The patch titled
     apm_event{,info}_t are userspace types
has been removed from the -mm tree.  Its filename was
     apm_eventinfo_t-are-userspace-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: apm_event{,info}_t are userspace types
From: Adam Jackson <ajax@redhat.com>

These types define the size of data read from /dev/apm_bios.  They should
not be hidden behind #ifdef __KERNEL__.

This is killing my xserver compile, apm_event_t is used in the xserver 
source.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/apm_bios.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/apm_bios.h~apm_eventinfo_t-are-userspace-types include/linux/apm_bios.h
--- a/include/linux/apm_bios.h~apm_eventinfo_t-are-userspace-types
+++ a/include/linux/apm_bios.h
@@ -18,6 +18,9 @@
 
 #include <linux/types.h>
 
+typedef unsigned short	apm_event_t;
+typedef unsigned short	apm_eventinfo_t;
+
 struct apm_bios_info {
 	__u16	version;
 	__u16	cseg;
@@ -32,9 +35,6 @@ struct apm_bios_info {
 
 #ifdef __KERNEL__
 
-typedef unsigned short	apm_event_t;
-typedef unsigned short	apm_eventinfo_t;
-
 #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
 #define APM_CS_16	(APM_CS + 8)
 #define APM_DS		(APM_CS_16 + 8)
_

Patches currently in -mm which might be from ajax@redhat.com are

origin.patch
