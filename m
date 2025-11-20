Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57D171CD
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763655876; cv=none; b=aroaPXBYu4cKeVVqxC1aRwQDTK65RqPTehDOIkhCTZWM3dNnkU16w79+m+oWKshtOS8MnTbMmNxJ8aQxHq38YHwZW0pycwQVqx92ayLk7c8jw1Inbpmoj7CERCoKL7LgQIUXsyFX0hh/pYOSiHBAj1AILXnB1PW8e/opQqBq0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763655876; c=relaxed/simple;
	bh=8IgKiG5WajYvRX5rnrHaZY8w65MIINIOyW2AkC4rJJA=;
	h=Date:To:From:Subject:Message-Id; b=KbCJB18TNccg/9h/4B0RJfhFq2l4OIr4jbc4VC/4ZW3DTU8vcB3ecvTaNK/FIuxgvaSX80V5QkaLBB6HdeOInLaObVVBzcq+mOLTg8klTcEmRsZeRsyar2DQjPFMj+yyDJRqG6FsMVduu2k6BAKjeust9uEOdGLI9cgEQeCdzhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkBaf8RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkBaf8RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A61C4CEF1;
	Thu, 20 Nov 2025 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763655875;
	bh=8IgKiG5WajYvRX5rnrHaZY8w65MIINIOyW2AkC4rJJA=;
	h=Date:To:From:Subject:From;
	b=QkBaf8RC3FmLK0vXOogL0Ijyfo1pYdBgB1uOI5hzAwK1QN+EKNlxxBc8UHmDKGiFL
	 FpS0eCW7xI48WW9xmeJK15IVe3E4OMNLImwl/+AilzT1bksLiHCWmb4aueNgdafNNi
	 taPga2UL/LehCOPDfJZJcJt/r9XP7mh71yFfwcfY=
Date: Thu, 20 Nov 2025 08:24:35 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,aliceryhl@google.com,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-inline-rb_last-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251120162435.D2A61C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rbtree-inline-rb_last-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-inline-rb_last-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-inline-rb_last-fix.patch

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

rbtree-inline-rb_first-fix.patch
rbtree-inline-rb_last-fix.patch

