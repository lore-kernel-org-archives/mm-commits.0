Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602B1E51D
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738542; cv=none; b=NA8iJ5+zN48BHlHtQf4Rr3RZPoK5H9fBcZ0bqtJy7wduZVBuOl3fMjs/kN87TZbcSOhdpPHloj8kxa1W5yjkPOX7PbHse1eFIzNmfEJwqUHpUNNrsLALyxbiRIzySrfclZ/xBIurK3qF+F5mwuRU2UbRE3FPFW6sQW/4ZDrxMcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738542; c=relaxed/simple;
	bh=XH1nKlL3jU7N2tjThs56uroW7hY6GqWAT+LI7tvzDZM=;
	h=Date:To:From:Subject:Message-Id; b=izVL8z3hUCOhyoLdU500AKPWJAjQzesciNfzHJppVHjNDPjgE7RlCpd85ecR+9va+edDPLaooKtLFHHQL0mMa6MQBqW/3nfMb2067fKQWq4rhsHJvddBjAuH3lO2X2lsgsqHMRYfIRubVpl9wvEZ3VwJPZrSX53PMedF4+qoOjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yp9OA0+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yp9OA0+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B31EC4CEC6;
	Thu, 24 Oct 2024 02:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738542;
	bh=XH1nKlL3jU7N2tjThs56uroW7hY6GqWAT+LI7tvzDZM=;
	h=Date:To:From:Subject:From;
	b=Yp9OA0+XKnlFhR84omEynNVe8xZKl97jRzqKw4eVvyZ5kmRmicOLKxN60HTbxN7uJ
	 iaYgZugjTQo/rpELrEg+GkU3Gi6eya1SAEi7Svhr9TKoWvyAFbuec+/8qVcJd351xK
	 K2FXnBWXxmsnrmqJRLHgNDAsMXnoHmUjBulz792Q=
Date: Wed, 23 Oct 2024 19:55:41 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch added to mm-nonmm-unstable branch
Message-Id: <20241024025542.3B31EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: cast percpu pointer in PERCPU_PTR() via unsigned long
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: cast percpu pointer in PERCPU_PTR() via unsigned long
Date: Mon, 21 Oct 2024 10:07:38 +0200

Cast pointer from percpu address space to generic (kernel) address space
in PERCPU_PTR() macro via unsigned long intermediate cast [1].  This
intermediate cast is also required to avoid build failure when GCC's
strict named address space checks for x86 targets [2] are enabled.

Found by GCC's named address space checks.

[1] https://sparse.docs.kernel.org/en/latest/annotations.html#address-space-name
[2] https://gcc.gnu.org/onlinedocs/gcc/Named-Address-Spaces.html#x86-Named-Address-Spaces

Link: https://lkml.kernel.org/r/20241021080856.48746-3-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/percpu-defs.h~percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long
+++ a/include/linux/percpu-defs.h
@@ -221,7 +221,10 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-	(typeof(*(__p)) __force __kernel *)(__p);
+({									\
+	unsigned long __pcpu_ptr = (__force unsigned long)(__p);	\
+	(typeof(*(__p)) __force __kernel *)(__pcpu_ptr);		\
+})
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch
percpu-merge-verify_percpu_ptr-into-its-only-user.patch
percpu-introduce-percpu_ptr-macro.patch
percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch

