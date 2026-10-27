Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124584;
	b=Fghzv2SNGmeRYXSutQDd8+SKeU6G+fkH7xphLCFnmXaN7zd42UzzXv5MVAcN8tQQFwUR
	 OCHFPubW54FXThYW62h4MOsCoWuLGrPjMsHLSnx11Ew/cyB5Lj/MSb8VXj+S9ps3+W6ua
	 KvuuhAeWfSBR0DbAozC6FhHeWPu6+RidRfL5S04SG+GWpzr7mqnkh7A9V92e0PHn3HJYO
	 u7MbD+tS0FKzHaRGNHR2MCPimKS6Ajd6u6ypqKwh0jTPtt6DQhwrH8twpshdqy3HybbX/
	 iq0hEGzSCl8KzrnZ0ksRZTf2oRKGZym6D+jMnmcx+myZ+wIgr19f75Zk6VpQf2whEZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124584;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HG8aTNvVbvYlQ+cTcAQ3f+wbQiW9pH3FjPu/AXi3yQY=;
	b=tLk0o5izFJ7Y/9RePqiuDwYFReZ68bfF/MCLkEfvyQhUUsfQNUwlYTu80FNX7v78faJK
	 4c/h3+DvfRyULCnjNm/6xQ42q25wXDqRhoE+pCCfqWXMksrAE6QC3zkjIVI4bZUUeBiSd
	 Y3HhJNpTqazVzihtj2JysLhjp52ceksI1iPmkE7hzzHQuDB3/8zVKwf3e//1B5kzzJIYc
	 jlqRv7vIhdKCnNtoicJhE8NhNwSYrDB6WLiWEVRiqDR4qOGnvs2V6S2EX6xsiOz1siLGp
	 tfdoc7MQ4NQYVkZm/So6eK64jiU2zEftJv3K432KfGIJPOv93CT/2CCkB802HYVB79A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cD8NZdVM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A8C606A31A
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cD8NZdVM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC81F01825;
	Tue, 27 Oct 2026 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793124583;
	bh=HG8aTNvVbvYlQ+cTcAQ3f+wbQiW9pH3FjPu/AXi3yQY=;
	h=Date:To:From:Subject;
	b=cD8NZdVMt/jGG71RNvQ0vaOz2wWrjJ0hk2x7jbGJDF6pBzqix+PxwIlONbbisnHXp
	 jyXJiiIKW/jm33P8k2aKkk7buuV7kzLFmMTplm4+WAH0JxgWIIywFW5NBfXpM/LWrj
	 BbdCDBbIjT1C7jb5Bbs3ig6guhjGHE2m4H+f9k/Y=
Date: Tue, 27 Oct 2026 11:09:43 -0700
To: mm-commits@vger.kernel.org,eva.kurchatova@virtuozzo.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlbfs-enforce-f_seal_exec-in-setattr.patch removed from -mm tree
Message-Id: <20261027180943.90AC81F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: hugetlbfs: enforce F_SEAL_EXEC in setattr
has been removed from the -mm tree.  Its filename was
     hugetlbfs-enforce-f_seal_exec-in-setattr.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Subject: hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Mon, 26 Oct 2026 10:40:38 +0100

F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
not check it. As a result, fchmod() can change the execute bits of a
sealed hugetlbfs memfd.

Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
to execute bits when F_SEAL_EXEC is set.

This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
fchmod() incorrectly succeeded after applying F_SEAL_EXEC.

LLM assistance was used to reuse the helper and revise the description.

[david@kernel.org: use common helper; fixup Fixes:]
Link: https://lore.kernel.org/20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org
Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Chris Mason <mason@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <sashiko-bot@kernel.org>
Cc: <stable@vger.kernel.org>
---

 fs/hugetlbfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6656807ce4377..7f5c3962b5d56 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
+#include <linux/memfd.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
@@ -841,6 +842,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (ia_valid & ATTR_MODE) {
+		error = memfd_check_seals_mode(info->seals, inode->i_mode,
+					       attr->ia_mode);
+		if (error)
+			return error;
+	}
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {


Patches currently in -mm which might be from eva.kurchatova@virtuozzo.com are


