From: akpm@linux-foundation.org
Subject: - partitions-fix-ldm-for-new-field-in-the-vol5-vblk.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:23 -0700
Message-ID: <200707172309.l6HN9NRo012368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936304AbXGQXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aia21@cam.ac.uk, aia21@cantab.net, ldm@flatcap.org, mm-commits@vger.kernel.org


The patch titled
     partitions: fix LDM for new field in the VOL5 VBLK
has been removed from the -mm tree.  Its filename was
     partitions-fix-ldm-for-new-field-in-the-vol5-vblk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: partitions: fix LDM for new field in the VOL5 VBLK
From: Anton Altaparmakov <aia21@cam.ac.uk>

Teach LDM about a new field encountered with Windows Vista.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
Cb: Richard Russon <ldm@flatcap.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |  137 ++++++++++++++++++++++++++++--------------
 fs/partitions/ldm.h |    2 
 2 files changed, 93 insertions(+), 46 deletions(-)

diff -puN fs/partitions/ldm.c~partitions-fix-ldm-for-new-field-in-the-vol5-vblk fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~partitions-fix-ldm-for-new-field-in-the-vol5-vblk
+++ a/fs/partitions/ldm.c
@@ -677,15 +677,24 @@ static bool ldm_create_data_partitions (
  * Return:  -1 Error, the calculated offset exceeded the size of the buffer
  *           n OK, a range-checked offset into buffer
  */
-static int ldm_relative (const u8 *buffer, int buflen, int base, int offset)
+static int ldm_relative(const u8 *buffer, int buflen, int base, int offset)
 {
 
 	base += offset;
-	if ((!buffer) || (offset < 0) || (base > buflen))
+	if (!buffer || offset < 0 || base > buflen) {
+		if (!buffer)
+			ldm_error("!buffer");
+		if (offset < 0)
+			ldm_error("offset (%d) < 0", offset);
+		if (base > buflen)
+			ldm_error("base (%d) > buflen (%d)", base, buflen);
 		return -1;
-	if ((base + buffer[base]) >= buflen)
+	}
+	if (base + buffer[base] >= buflen) {
+		ldm_error("base (%d) + buffer[base] (%d) >= buflen (%d)", base,
+				buffer[base], buflen);
 		return -1;
-
+	}
 	return buffer[base] + offset + 1;
 }
 
@@ -1054,60 +1063,98 @@ static bool ldm_parse_prt3(const u8 *buf
  * Return:  'true'   @vb contains a Volume VBLK
  *          'false'  @vb contents are not defined
  */
-static bool ldm_parse_vol5 (const u8 *buffer, int buflen, struct vblk *vb)
+static bool ldm_parse_vol5(const u8 *buffer, int buflen, struct vblk *vb)
 {
-	int r_objid, r_name, r_vtype, r_child, r_size, r_id1, r_id2, r_size2;
-	int r_drive, len;
+	int r_objid, r_name, r_vtype, r_disable_drive_letter, r_child, r_size;
+	int r_id1, r_id2, r_size2, r_drive, len;
 	struct vblk_volu *volu;
 
-	BUG_ON (!buffer || !vb);
-
-	r_objid  = ldm_relative (buffer, buflen, 0x18, 0);
-	r_name   = ldm_relative (buffer, buflen, 0x18, r_objid);
-	r_vtype  = ldm_relative (buffer, buflen, 0x18, r_name);
-	r_child  = ldm_relative (buffer, buflen, 0x2E, r_vtype);
-	r_size   = ldm_relative (buffer, buflen, 0x3E, r_child);
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_ID1)
-		r_id1 = ldm_relative (buffer, buflen, 0x53, r_size);
-	else
+	BUG_ON(!buffer || !vb);
+	r_objid = ldm_relative(buffer, buflen, 0x18, 0);
+	if (r_objid < 0) {
+		ldm_error("r_objid %d < 0", r_objid);
+		return false;
+	}
+	r_name = ldm_relative(buffer, buflen, 0x18, r_objid);
+	if (r_name < 0) {
+		ldm_error("r_name %d < 0", r_name);
+		return false;
+	}
+	r_vtype = ldm_relative(buffer, buflen, 0x18, r_name);
+	if (r_vtype < 0) {
+		ldm_error("r_vtype %d < 0", r_vtype);
+		return false;
+	}
+	r_disable_drive_letter = ldm_relative(buffer, buflen, 0x18, r_vtype);
+	if (r_disable_drive_letter < 0) {
+		ldm_error("r_disable_drive_letter %d < 0",
+				r_disable_drive_letter);
+		return false;
+	}
+	r_child = ldm_relative(buffer, buflen, 0x2D, r_disable_drive_letter);
+	if (r_child < 0) {
+		ldm_error("r_child %d < 0", r_child);
+		return false;
+	}
+	r_size = ldm_relative(buffer, buflen, 0x3D, r_child);
+	if (r_size < 0) {
+		ldm_error("r_size %d < 0", r_size);
+		return false;
+	}
+	if (buffer[0x12] & VBLK_FLAG_VOLU_ID1) {
+		r_id1 = ldm_relative(buffer, buflen, 0x52, r_size);
+		if (r_id1 < 0) {
+			ldm_error("r_id1 %d < 0", r_id1);
+			return false;
+		}
+	} else
 		r_id1 = r_size;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_ID2)
-		r_id2 = ldm_relative (buffer, buflen, 0x53, r_id1);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_ID2) {
+		r_id2 = ldm_relative(buffer, buflen, 0x52, r_id1);
+		if (r_id2 < 0) {
+			ldm_error("r_id2 %d < 0", r_id2);
+			return false;
+		}
+	} else
 		r_id2 = r_id1;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_SIZE)
-		r_size2 = ldm_relative (buffer, buflen, 0x53, r_id2);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_SIZE) {
+		r_size2 = ldm_relative(buffer, buflen, 0x52, r_id2);
+		if (r_size2 < 0) {
+			ldm_error("r_size2 %d < 0", r_size2);
+			return false;
+		}
+	} else
 		r_size2 = r_id2;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE)
-		r_drive = ldm_relative (buffer, buflen, 0x53, r_size2);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE) {
+		r_drive = ldm_relative(buffer, buflen, 0x52, r_size2);
+		if (r_drive < 0) {
+			ldm_error("r_drive %d < 0", r_drive);
+			return false;
+		}
+	} else
 		r_drive = r_size2;
-
 	len = r_drive;
-	if (len < 0)
+	if (len < 0) {
+		ldm_error("len %d < 0", len);
 		return false;
-
+	}
 	len += VBLK_SIZE_VOL5;
-	if (len != BE32 (buffer + 0x14))
+	if (len > BE32(buffer + 0x14)) {
+		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
+				BE32(buffer + 0x14));
 		return false;
-
+	}
 	volu = &vb->vblk.volu;
-
-	ldm_get_vstr (buffer + 0x18 + r_name,  volu->volume_type,
-		sizeof (volu->volume_type));
-	memcpy (volu->volume_state, buffer + 0x19 + r_vtype,
-			sizeof (volu->volume_state));
-	volu->size = ldm_get_vnum (buffer + 0x3E + r_child);
-	volu->partition_type = buffer[0x42 + r_size];
-	memcpy (volu->guid, buffer + 0x43 + r_size,  sizeof (volu->guid));
+	ldm_get_vstr(buffer + 0x18 + r_name, volu->volume_type,
+			sizeof(volu->volume_type));
+	memcpy(volu->volume_state, buffer + 0x18 + r_disable_drive_letter,
+			sizeof(volu->volume_state));
+	volu->size = ldm_get_vnum(buffer + 0x3D + r_child);
+	volu->partition_type = buffer[0x41 + r_size];
+	memcpy(volu->guid, buffer + 0x42 + r_size, sizeof(volu->guid));
 	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE) {
-		ldm_get_vstr (buffer + 0x53 + r_size,  volu->drive_hint,
-			sizeof (volu->drive_hint));
+		ldm_get_vstr(buffer + 0x52 + r_size, volu->drive_hint,
+				sizeof(volu->drive_hint));
 	}
 	return true;
 }
diff -puN fs/partitions/ldm.h~partitions-fix-ldm-for-new-field-in-the-vol5-vblk fs/partitions/ldm.h
--- a/fs/partitions/ldm.h~partitions-fix-ldm-for-new-field-in-the-vol5-vblk
+++ a/fs/partitions/ldm.h
@@ -68,7 +68,7 @@ struct parsed_partitions;
 #define VBLK_SIZE_DSK3		12
 #define VBLK_SIZE_DSK4		45
 #define VBLK_SIZE_PRT3		28
-#define VBLK_SIZE_VOL5		59
+#define VBLK_SIZE_VOL5		58
 
 /* component types */
 #define COMP_STRIPE		0x01		/* Stripe-set */
_

Patches currently in -mm which might be from aia21@cam.ac.uk are

origin.patch
introduce-i_sync.patch
