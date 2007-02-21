From: akpm@linux-foundation.org
Subject: - autofs4-header-file-update.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:11 -0800
Message-ID: <200702211046.l1LAkBR7006448@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964945AbXBUKq2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: header file update
has been removed from the -mm tree.  Its filename was
     autofs4-header-file-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs4: header file update
From: Ian Kent <raven@themaw.net>

The current header file definitions for autofs version 5 have caused a couple
of problems for application builds downstream.

This fixes the problem by separating the definitions.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c       |   12 ++++++++----
 include/linux/auto_fs4.h |   16 ++++++++++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-header-file-update fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-header-file-update
+++ a/fs/autofs4/waitq.c
@@ -84,7 +84,11 @@ static void autofs4_notify_daemon(struct
 				 struct autofs_wait_queue *wq,
 				 int type)
 {
-	union autofs_packet_union pkt;
+	union {
+		struct autofs_packet_hdr hdr;
+		union autofs_packet_union v4_pkt;
+		union autofs_v5_packet_union v5_pkt;
+	} pkt;
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
@@ -98,7 +102,7 @@ static void autofs4_notify_daemon(struct
 	/* Kernel protocol v4 missing and expire packets */
 	case autofs_ptype_missing:
 	{
-		struct autofs_packet_missing *mp = &pkt.missing;
+		struct autofs_packet_missing *mp = &pkt.v4_pkt.missing;
 
 		pktsz = sizeof(*mp);
 
@@ -110,7 +114,7 @@ static void autofs4_notify_daemon(struct
 	}
 	case autofs_ptype_expire_multi:
 	{
-		struct autofs_packet_expire_multi *ep = &pkt.expire_multi;
+		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
 
 		pktsz = sizeof(*ep);
 
@@ -129,7 +133,7 @@ static void autofs4_notify_daemon(struct
 	case autofs_ptype_missing_direct:
 	case autofs_ptype_expire_direct:
 	{
-		struct autofs_v5_packet *packet = &pkt.v5_packet;
+		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
 
 		pktsz = sizeof(*packet);
 
diff -puN include/linux/auto_fs4.h~autofs4-header-file-update include/linux/auto_fs4.h
--- a/include/linux/auto_fs4.h~autofs4-header-file-update
+++ a/include/linux/auto_fs4.h
@@ -59,6 +59,13 @@ struct autofs_packet_expire_multi {
 	char name[NAME_MAX+1];
 };
 
+union autofs_packet_union {
+	struct autofs_packet_hdr hdr;
+	struct autofs_packet_missing missing;
+	struct autofs_packet_expire expire;
+	struct autofs_packet_expire_multi expire_multi;
+};
+
 /* autofs v5 common packet struct */
 struct autofs_v5_packet {
 	struct autofs_packet_hdr hdr;
@@ -78,12 +85,13 @@ typedef struct autofs_v5_packet autofs_p
 typedef struct autofs_v5_packet autofs_packet_missing_direct_t;
 typedef struct autofs_v5_packet autofs_packet_expire_direct_t;
 
-union autofs_packet_union {
+union autofs_v5_packet_union {
 	struct autofs_packet_hdr hdr;
-	struct autofs_packet_missing missing;
-	struct autofs_packet_expire expire;
-	struct autofs_packet_expire_multi expire_multi;
 	struct autofs_v5_packet v5_packet;
+	autofs_packet_missing_indirect_t missing_indirect;
+	autofs_packet_expire_indirect_t expire_indirect;
+	autofs_packet_missing_direct_t missing_direct;
+	autofs_packet_expire_direct_t expire_direct;
 };
 
 #define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
_

Patches currently in -mm which might be from raven@themaw.net are
