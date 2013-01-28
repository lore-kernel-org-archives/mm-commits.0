From: akpm@linux-foundation.org
Subject: [wrecked] userns-improve-uid-gid-map-collision-detection.patch removed from -mm tree
Date: Mon, 28 Jan 2013 13:38:07 -0800
Message-ID: <20130128213808.00F2531C231@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42919 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3A1ViJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 16:38:09 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so196947qaj.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 13:38:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userns: improve uid/gid map collision detection
has been removed from the -mm tree.  Its filename was
     userns-improve-uid-gid-map-collision-detection.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: userns: improve uid/gid map collision detection

Initial implementation of the uid/gid maps (/proc/<pid>/{u,g}id_map) will
enforce that the UID and GID maps be written in strict order as a simple
way to check for range collision:

	local id	mapped to	count/range
	0		1000		50
	(ids 0-50 get mapped to 1000-1050)
	100		2120		10
	500		5000		200

so for each new entry, local id must be bigger than last local id (plus
count) and the ids it maps to also needs to be bigger than the last entry
(plus count).

This makes impossible to have a use case like this:
	local id	mapped to	count/range
	0		1000		1
	48		500		20

because while 48+20 > 0+1, 500+20 < 1000+1.

This patch implements a more elaborate collision detection allowing any
order to be used.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN kernel/user_namespace.c~userns-improve-uid-gid-map-collision-detection kernel/user_namespace.c
--- a/kernel/user_namespace.c~userns-improve-uid-gid-map-collision-detection
+++ a/kernel/user_namespace.c
@@ -521,6 +521,28 @@ struct seq_operations proc_projid_seq_op
 
 static DEFINE_MUTEX(id_map_mutex);
 
+#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
+static inline int extent_collision(struct uid_gid_map *new_map,
+				   struct uid_gid_extent *extent)
+{
+	int i;
+	struct uid_gid_extent *cur;
+
+	for (i = 0; i < new_map->nr_extents; i++) {
+		cur = &new_map->extent[i];
+		if (in_range(extent->first, cur->first, cur->count) ||
+		    in_range(extent->first + extent->count, cur->first,
+			     cur->count))
+			return 1;
+		if (in_range(extent->lower_first, cur->lower_first,
+			     cur->count) ||
+		    in_range(extent->lower_first + extent->count,
+			     cur->lower_first, cur->count))
+			return 1;
+	}
+	return 0;
+}
+
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -634,10 +656,7 @@ static ssize_t map_write(struct file *fi
 		if ((extent->lower_first + extent->count) <= extent->lower_first)
 			goto out;
 
-		/* For now only accept extents that are strictly in order */
-		if (last &&
-		    (((last->first + last->count) > extent->first) ||
-		     ((last->lower_first + last->count) > extent->lower_first)))
+		if (extent_collision(&new_map, extent))
 			goto out;
 
 		new_map.nr_extents++;
_

Patches currently in -mm which might be from aris@redhat.com are

userns-improve-uid-gid-map-collision-detection-fix.patch

