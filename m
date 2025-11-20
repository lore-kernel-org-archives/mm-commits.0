Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0E376BC3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763655873; cv=none; b=mE7ctRIL80b26BLMECX6s7oRdKNTIYzbNi7C6sK9p9F/CEfNe/shH7JYLXQJLJNjn4UyW1WZfMqQjjrn4iIpeXkySXuUSsD7JG4T5iE+x/uZLNDIXJi35USxFLG/PpPWgbx3GvXWEZrcqQqKO0OL0QKIUqZVul6UD5On6tKFFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763655873; c=relaxed/simple;
	bh=HzkIVGtC0lnKhchEqXLzAniwOwMJU15/AN/3f9vCJn0=;
	h=Date:To:From:Subject:Message-Id; b=npNEiiNDBBi+qWT+a0p/yQd+5DuLLx20lk76NYw38GJ6d2yxgQLUFIvgdRn1ibIoGS6nf2y1YLnB8aKx7rc6RIaTsiQKlyCtrTPruXhV5lKdG809m6g0xuBZwcLUKPOi7MepkH763+9hO/4FCqI97WFI0BZHDGHIE8Qi1tIaUMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1Uc81AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1Uc81AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C30C4CEF1;
	Thu, 20 Nov 2025 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763655873;
	bh=HzkIVGtC0lnKhchEqXLzAniwOwMJU15/AN/3f9vCJn0=;
	h=Date:To:From:Subject:From;
	b=H1Uc81ABhQBUrboFCYtnonzAbZ5jdBROQDXwoWHs2E7iex8KBXpfGeWCs8fGolGjl
	 EUk+NHTXhhJba8k+avpuTw8cWEVoKf5/oA+eOsEs2kDnF4Ac2U8xIAAGxVR3N7SXmk
	 tmwe7y3Ln+s+CaxJQyBxGJpkfcq76ZaNcxXb/iqQ=
Date: Thu, 20 Nov 2025 08:24:32 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-inline-rb_first-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251120162433.67C30C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rbtree-inline-rb_first-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-inline-rb_first-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-inline-rb_first-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

rbtree-inline-rb_first-fix.patch
rbtree-inline-rb_last-fix.patch

