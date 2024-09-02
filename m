Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833BF146A6F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248803; cv=none; b=AbAuHOXf7SJeAxs4oao3YXJkdwoamDpqn1T119BdpaGNFLnXthW/q6gX8a6JwbbtNBF0NSxjloVrbkGpf+pI0E1BiGMwrEjXRYsUTDTDGZ2Qp3TyTHlN/LgNJULeYMCMsGpyejGCEF1jnEMI3oy9u3wlb6xw4mv/mjPw9CqiZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248803; c=relaxed/simple;
	bh=jyAzjg6dA/XM8gc8BHhoMSlXHnJi6RSfVNGal4v8KWo=;
	h=Date:To:From:Subject:Message-Id; b=R+f1s5N15mC9wL3yy9H5Sbb3nMAa7xuhKxVLX/aEQEE75w6XvBoKBrJecZY/FnJrJHrL0XMEsECu+sy8uj2oBlPiJpHTxRja+Pmm0260Md32XmLN/pBcNfpliDLP69VrEu921liFmuxqiAgq/qU/w7bBAgPtK4kzZ+wQCLI27pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JkQKp39A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JkQKp39A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F11C4CEC2;
	Mon,  2 Sep 2024 03:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248803;
	bh=jyAzjg6dA/XM8gc8BHhoMSlXHnJi6RSfVNGal4v8KWo=;
	h=Date:To:From:Subject:From;
	b=JkQKp39AzmCTFD3XoJ8Lb5h8XkPur4mwkD5A/Uue1ol671HQOvEAAZ+02EJK1KahU
	 K8wKKXQQT0GhUlAfcQaYrfuqqUx/KOllmN4RXLTCoN7gmQD6djskVikXRg9sfYzQ3a
	 tdTannz0EesThLvv6qTvDKI7vw4l808p67iwTZCo=
Date: Sun, 01 Sep 2024 20:46:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,penguin-kernel@I-love.SAKURA.ne.jp,mingo@redhat.com,longman@redhat.com,cmllamas@google.com,boqun.feng@gmail.com,hooanon05g@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lockdep-upper-limit-lockdep_chains_bits.patch removed from -mm tree
Message-Id: <20240902034643.58F11C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lockdep: upper limit LOCKDEP_CHAINS_BITS
has been removed from the -mm tree.  Its filename was
     lockdep-upper-limit-lockdep_chains_bits.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: lockdep: upper limit LOCKDEP_CHAINS_BITS
Date: Tue, 23 Jul 2024 16:40:17 +0000

CONFIG_LOCKDEP_CHAINS_BITS value decides the size of chain_hlocks[] in
kernel/locking/lockdep.c, and it is checked by add_chain_cache() with
    BUILD_BUG_ON((1UL << 24) <= ARRAY_SIZE(chain_hlocks));
This patch is just to silence BUILD_BUG_ON().

See also https://lore.kernel.org/all/30795.1620913191@jrobl/

[cmllamas@google.com: fix minor checkpatch issues in commit log]
Link: https://lkml.kernel.org/r/20240723164018.2489615-1-cmllamas@google.com
Signed-off-by: J. R. Okajima <hooanon05g@gmail.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lockdep-upper-limit-lockdep_chains_bits
+++ a/lib/Kconfig.debug
@@ -1515,7 +1515,7 @@ config LOCKDEP_BITS
 config LOCKDEP_CHAINS_BITS
 	int "Bitsize for MAX_LOCKDEP_CHAINS"
 	depends on LOCKDEP && !LOCKDEP_SMALL
-	range 10 30
+	range 10 21
 	default 16
 	help
 	  Try increasing this value if you hit "BUG: MAX_LOCKDEP_CHAINS too low!" message.
_

Patches currently in -mm which might be from hooanon05g@gmail.com are


