From: akpm@linux-foundation.org
Subject: - md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:58 -0700
Message-ID: <200705092154.l49Lsw4M003215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759332AbXEIVzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     md: remove the slash from the name of a kmem_cache used by raid5
has been removed from the -mm tree.  Its filename was
     md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: remove the slash from the name of a kmem_cache used by raid5
From: NeilBrown <neilb@suse.de>

SLUB doesn't like slashes as it wants to use the cache name as the name of a
directory (or symlink) in sysfs.

Signed-off-by: Neil Brown <neilb@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid5.c~md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5
+++ a/drivers/md/raid5.c
@@ -353,8 +353,8 @@ static int grow_stripes(raid5_conf_t *co
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5/%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5/%s-alt", mdname(conf->mddev));
+	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
