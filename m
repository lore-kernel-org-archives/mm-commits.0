Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD0216E1B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084635; cv=none; b=ZBiO7btaULsM8gYsuLS+9OS4hmbMYITt6/nKRdget/W+g2/8udj93TAlHrkeDoEWGU+/hvEa3UvoTgZJR1h4ePsTItwCpaWoYZavQGXgm+pZRC6FsZw0QNkFacV8CecL4aHDHv4NQNPRshwU/w6jKI3XFYg7WROQJKNcU7kjbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084635; c=relaxed/simple;
	bh=qDcdF9iqLV33fYRK49CUmMXnJ3DF7EoFXrK0F5OV86o=;
	h=Date:To:From:Subject:Message-Id; b=Qyi0Rdzj5G4Fa3AEMSeihUg1w03jHGruiIh5d6JrcxQCakS9/ifOn+iA3TnMUMdlOIaaeAQpKfvk6T7Q/hnGPU5qOyiwg8TuP6g8Z25/6dhR3RlMzZx2x9S1hvtjV9JzBT76U7JL3cAXnyAZjmm8mkJS60iarW8N81ndSZXPDsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jyTZhTU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jyTZhTU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851C1C116B1;
	Sun, 28 Sep 2025 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084635;
	bh=qDcdF9iqLV33fYRK49CUmMXnJ3DF7EoFXrK0F5OV86o=;
	h=Date:To:From:Subject:From;
	b=jyTZhTU8qaJRmbQgNuruPTL5Ke5prUDhiGiQV7t0HXUNZuDuX5wan6lexuiN87mmY
	 Rx4snhpaM/POK1V+O85UopEVimKOpr0pfvHWmd+nDcis/QD5w3XCff2v5vRmBW27Vo
	 73A6SPPfIS32WUt0iEx+Dkl3mny9hdUYIqrngkYU=
Date: Sun, 28 Sep 2025 11:37:15 -0700
To: mm-commits@vger.kernel.org,rgoldwyn@suse.de,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-double-free-in-user_cluster_connect.patch removed from -mm tree
Message-Id: <20250928183715.851C1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix double free in user_cluster_connect()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-double-free-in-user_cluster_connect.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: ocfs2: fix double free in user_cluster_connect()
Date: Tue, 23 Sep 2025 14:26:07 +0300

user_cluster_disconnect() frees "conn->cc_private" which is "lc" but then
the error handling frees "lc" a second time.  Set "lc" to NULL on this
path to avoid a double free.

Link: https://lkml.kernel.org/r/aNKDz_7JF7aycZ0k@stanley.mountain
Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/stack_user.c~ocfs2-fix-double-free-in-user_cluster_connect
+++ a/fs/ocfs2/stack_user.c
@@ -1011,6 +1011,7 @@ static int user_cluster_connect(struct o
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


