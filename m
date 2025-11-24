Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4C21CFFA
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764026157; cv=none; b=SHhbdclL/lhEcsb05EUd9f/1DeO5mZVvYRtpE6nK561ZQv/pPP9k9h3SbhWpFCPSOe1ONfXzLlVgFKmnsTEvmGGPNBQx8hFoHF4HjhlyAWQEJGUx8F+sfgItYG5ku49DqoqVqFVWeGAWpjIixJfkD8L0nAFeOvlEC178hM5o/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764026157; c=relaxed/simple;
	bh=jMWqFdoZ9VEszUk3iOzw4EnAiGYXhoG8eguX7fvfDy4=;
	h=Date:To:From:Subject:Message-Id; b=RXtrtmggLcotbRDjS6CLLqcjyoU0wfUcss+cOTTIePsY09iwK8D+5ZhoJWjwS1qbmE9kgcmGimrprNlsgXIYrhji70/cFTodJI0jGrp5EIAH4W+QMDoAHJNpPOdTfWoLrFH6Fugaz1BR24u6ktxSG/B04oGLzsUluCyC7eUN4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHBCESgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHBCESgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC1AC4CEFB;
	Mon, 24 Nov 2025 23:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764026156;
	bh=jMWqFdoZ9VEszUk3iOzw4EnAiGYXhoG8eguX7fvfDy4=;
	h=Date:To:From:Subject:From;
	b=PHBCESgXXKsTAptV1SEEK0EkQG0Sj8lPnnWJKZuYjW4WIGK1EQ/2s61Do0R+l89Tr
	 LVQ/gkeRgTEu/yQ4y+sMecHNpwAz/LCG7A+byty/kgsRzBpkxkIHoMeNHVGZ/bIr10
	 qXKpRpFpeLl2cxNart0faeRI9i/pg6aH4s4Eq/+0=
Date: Mon, 24 Nov 2025 15:15:55 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] rbtree-inline-rb_first-fix.patch removed from -mm tree
Message-Id: <20251124231556.7CC1AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rbtree-inline-rb_first-fix
has been removed from the -mm tree.  Its filename was
     rbtree-inline-rb_first-fix.patch

This patch was dropped because it was folded into rbtree-inline-rb_first.patch

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: rbtree-inline-rb_first-fix
Date: Thu, 20 Nov 2025 09:55:18 +0100

fix rust build

Link: https://lkml.kernel.org/r/20251120085518.1463498-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reported-by: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/rbtree.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/rust/helpers/rbtree.c~rbtree-inline-rb_first-fix
+++ a/rust/helpers/rbtree.c
@@ -7,3 +7,8 @@ void rust_helper_rb_link_node(struct rb_
 {
 	rb_link_node(node, parent, rb_link);
 }
+
+struct rb_node *rust_helper_rb_first(const struct rb_root *root)
+{
+	return rb_first(root);
+}
_

Patches currently in -mm which might be from ojeda@kernel.org are

rbtree-inline-rb_first.patch
rbtree-inline-rb_last-fix.patch

