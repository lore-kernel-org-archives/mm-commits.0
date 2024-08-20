Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF56D14AD2B;
	Tue, 20 Aug 2024 23:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196458; cv=none; b=KCnWUrjpEk3TeS8NJhRhU9dZGVFtqpxWA0CyR2XsST0LdGer4DGx/AeWiWHSX+brtC+UXR6R5OcElM4FOCY20xncupnVRSFTFQDmv75sznyZ2N0sOfVui2mKudRno7f95nyHrb7Ni+8lTbrn5PaX8X4PXRXYJdGDGDIPxuriCu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196458; c=relaxed/simple;
	bh=MyFJJaII4UYwmlMtCN1h5B1KLyLGvVHISgNJjtrGOp4=;
	h=Date:To:From:Subject:Message-Id; b=U5/0uHTz1FL1+E6S+mRW1AzgY18zlHmiWku9+HG8naYY+njGzRjW9BNolwwPbCi4DTgmP1NF6u6zPa+IYIbGp8pHRS2M/Zy5Cf+giTeV4SNxAeErJA15uPKaFe96IH9m30C+zOZsD798eKscXUQ6mIw+r2S/Q+OQBaYMd7Qog6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKwZcALh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKwZcALh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35166C4AF0B;
	Tue, 20 Aug 2024 23:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724196458;
	bh=MyFJJaII4UYwmlMtCN1h5B1KLyLGvVHISgNJjtrGOp4=;
	h=Date:To:From:Subject:From;
	b=SKwZcALh4NmkpfR32gRLetSIfAGCSeUvRNEmGbdNEq1+b8XLbnLB9mXXmWxAX19Jw
	 G3rd67HMW1BZA2AxJeRSzFxcoNyKg+q17gz34AxwtDJn6RN27MiVSj5kOKg4giuZkl
	 +QQCXBLkuYSYJoPKVvqfxV8lCZ0iHWfmX31zhghc=
Date: Tue, 20 Aug 2024 16:27:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,paulmck@kernel.org,hdanton@sina.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-rcu_read_lock-from-mt_validate.patch added to mm-hotfixes-unstable branch
Message-Id: <20240820232738.35166C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove rcu_read_lock() from mt_validate()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-remove-rcu_read_lock-from-mt_validate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-rcu_read_lock-from-mt_validate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: remove rcu_read_lock() from mt_validate()
Date: Tue, 20 Aug 2024 13:54:17 -0400

The write lock should be held when validating the tree to avoid updates
racing with checks.  Holding the rcu read lock during a large tree
validation may also cause a prolonged rcu read window and "rcu_preempt
detected stalls" warnings.

Link: https://lore.kernel.org/all/0000000000001d12d4062005aea1@google.com/
Link: https://lkml.kernel.org/r/20240820175417.2782532-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reported-by: syzbot+036af2f0c7338a33b0cd@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-rcu_read_lock-from-mt_validate
+++ a/lib/maple_tree.c
@@ -7566,14 +7566,14 @@ static void mt_validate_nulls(struct map
  * 2. The gap is correctly set in the parents
  */
 void mt_validate(struct maple_tree *mt)
+	__must_hold(mas->tree->ma_lock)
 {
 	unsigned char end;
 
 	MA_STATE(mas, mt, 0, 0);
-	rcu_read_lock();
 	mas_start(&mas);
 	if (!mas_is_active(&mas))
-		goto done;
+		return;
 
 	while (!mte_is_leaf(mas.node))
 		mas_descend(&mas);
@@ -7594,9 +7594,6 @@ void mt_validate(struct maple_tree *mt)
 		mas_dfs_postorder(&mas, ULONG_MAX);
 	}
 	mt_validate_nulls(mt);
-done:
-	rcu_read_unlock();
-
 }
 EXPORT_SYMBOL_GPL(mt_validate);
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch

