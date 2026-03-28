Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB822B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671907; cv=none; b=HW2Oifm5f65gP7XyvBJj32Y1v07Ih0PpTDalrGch44I6ZgY1jf2HM12wf2Q7JiJxV4TUVrqjUlX57Nt8gPENwsewDCj0Z8dRDDG7dH1zHHyr4dkdicr7x68QeclxnM1aOFtLhA7ph0gVMwLM+Xsw1VVWx6dfO94l6WwzzfpdkwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671907; c=relaxed/simple;
	bh=Ivos4Oq7LsXC/Z4TjJP1/yiLE2JBEFXJg1vInGVlzbQ=;
	h=Date:To:From:Subject:Message-Id; b=OG9TsMcWMaERV8S+i7Tf9yNwToFSsNuhUT+Y/uxFiYhEmNrOck0FzeE4m7F+JziMr1owYyU1jeyVTEwEEJZkjAkzZ0EjnaYXR1X9sl91wcduCd3C4zOpGUOwtFmYw9JymZOZ+UAaL+FFs5JVhoPpRw7MoywrIn4Mjkb6Vb5NAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JG2jGJzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JG2jGJzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200D2C4CEF7;
	Sat, 28 Mar 2026 04:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671907;
	bh=Ivos4Oq7LsXC/Z4TjJP1/yiLE2JBEFXJg1vInGVlzbQ=;
	h=Date:To:From:Subject:From;
	b=JG2jGJzQ+PJvefZIu0y7x7zzswBDMDmDd9iy8G6tF/wXNmPt6uWU8OLnswb8lhaH7
	 xF+eZYUCMGeg0CMC4HwF5iKad0COB2Cvo9R7oFVSbvPMdez2tStnuHPPQHdjebBiPY
	 HI+kMmR1q1eX3dcmd0uOHi9KsykZzTyjtur1KuvY=
Date: Fri, 27 Mar 2026 21:25:06 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch removed from -mm tree
Message-Id: <20260328042507.200D2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: use sysfs_emit in sysfs show functions
has been removed from the -mm tree.  Its filename was
     crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: use sysfs_emit in sysfs show functions
Date: Sun, 1 Mar 2026 13:51:07 +0100

Replace sprintf() with sysfs_emit() in sysfs show functions.  sysfs_emit()
is preferred for formatting sysfs output because it provides safer bounds
checking.  No functional changes.

Link: https://lkml.kernel.org/r/20260301125106.911980-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-use-sysfs_emit-in-sysfs-show-functions
+++ a/kernel/crash_dump_dm_crypt.c
@@ -6,6 +6,7 @@
 #include <linux/cc_platform.h>
 #include <linux/configfs.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
 
 #define KEY_NUM_MAX 128	/* maximum dm crypt keys */
 #define KEY_SIZE_MAX 256	/* maximum dm crypt key size */
@@ -189,7 +190,7 @@ static inline struct config_key *to_conf
 
 static ssize_t config_key_description_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%s\n", to_config_key(item)->description);
+	return sysfs_emit(page, "%s\n", to_config_key(item)->description);
 }
 
 static ssize_t config_key_description_store(struct config_item *item,
@@ -265,7 +266,7 @@ static struct config_item *config_keys_m
 
 static ssize_t config_keys_count_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", key_count);
+	return sysfs_emit(page, "%d\n", key_count);
 }
 
 CONFIGFS_ATTR_RO(config_keys_, count);
@@ -274,7 +275,7 @@ static bool is_dm_key_reused;
 
 static ssize_t config_keys_reuse_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", is_dm_key_reused);
+	return sysfs_emit(page, "%d\n", is_dm_key_reused);
 }
 
 static ssize_t config_keys_reuse_store(struct config_item *item,
@@ -321,7 +322,7 @@ static bool restore;
 
 static ssize_t config_keys_restore_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", restore);
+	return sysfs_emit(page, "%d\n", restore);
 }
 
 static ssize_t config_keys_restore_store(struct config_item *item,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


