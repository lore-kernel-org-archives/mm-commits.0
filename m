Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F451A295
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764026181; cv=none; b=mTxfbhUFA6MmNZTH90NmQtExzDcAPGoiKKJBeh2gme+wA9ItNOV3VhP9kq/IGHKiqA9fKmyRk9YK2PHtCMi2k9J3LwwIzqrygIh3+Af3Qmar86pI09+UOzR9gqJjc7jktCoG+rMnPdkbjUbizWfqhk/mUI1HYvmol+7FZPB09Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764026181; c=relaxed/simple;
	bh=DMXPPKiGQuQnYWI4kqgCYFaoi3/8ejdDOvOecOa23Bs=;
	h=Date:To:From:Subject:Message-Id; b=QQ8hEsMX2gufZ6vmT2KJgVFKxQkqabsh6gkgdkYCjrlU8gptkFAKkRMjoNImiTswzN3u7xQ5/AmX0nobXg1SzeWl5Mr7woqvdL8w/GjA2QLEk4Ifp+cp35WImBi8R3o4pHhL1iYlubGLi2bcDBOnkiB+VxNGxJdyImwy9u/9LEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ge1NX+K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ge1NX+K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D4CC4CEF1;
	Mon, 24 Nov 2025 23:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764026181;
	bh=DMXPPKiGQuQnYWI4kqgCYFaoi3/8ejdDOvOecOa23Bs=;
	h=Date:To:From:Subject:From;
	b=Ge1NX+K8yl73Ebg5B1IhO45xQp+bRc1qyw/7VbCYSJkDHRgdKxKPgqsl4R1n8BBh6
	 zbLT0xGRlBFKVc/4jz2mBlk3qVTb3Y19Akr34964FX3+kW4kz1q+OCQpnpuPud/jcu
	 twMeGPWGeqIFQuAw8D7p2IgKbsvam6q72QaeI/mw=
Date: Mon, 24 Nov 2025 15:16:20 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] rbtree-inline-rb_last-fix.patch removed from -mm tree
Message-Id: <20251124231620.F0D4CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rbtree-inline-rb_last-fix
has been removed from the -mm tree.  Its filename was
     rbtree-inline-rb_last-fix.patch

This patch was dropped because it was folded into rbtree-inline-rb_last.patch

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: rbtree-inline-rb_last-fix
Date: Thu, 20 Nov 2025 09:55:18 +0100

fix rust build

Link: https://lkml.kernel.org/r/20251120085518.1463498-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Reported-by: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/rbtree.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/rust/helpers/rbtree.c~rbtree-inline-rb_last-fix
+++ a/rust/helpers/rbtree.c
@@ -12,3 +12,8 @@ struct rb_node *rust_helper_rb_first(con
 {
 	return rb_first(root);
 }
+
+struct rb_node *rust_helper_rb_last(const struct rb_root *root)
+{
+	return rb_last(root);
+}
_

Patches currently in -mm which might be from ojeda@kernel.org are

rbtree-inline-rb_last.patch

