Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B228A1D4611
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802158; cv=none; b=gZEvLV7fKt1VdR4dLayXKtIqr9DJhHlB57j7VR382Tvt8w7WmDCfMaqX/ay1NXYML5djw5E5Xz1uxZSWlsrdW9EEpdYJD4ICIcvtuxR5m2+ryMD2GVcaQ35rGIpHgGUjFdhxq3Ve8DOivd4vhbVeHTiodD0cv8ZolLSfpk4aYgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802158; c=relaxed/simple;
	bh=qC+4ew/VxVYwZ7kRBVFcHvdv4M2mK3ga/Tc4A5849qI=;
	h=Date:To:From:Subject:Message-Id; b=QJusI8y0IaUdwvW3JEInsSr0sQQVaqJ4+T96gxB1q0EzfIQCkCDPKPIpKy8Ie5MbWWIOl+GpE2Curr5FhwTYvtZ1vNdVbXV4TX29Lzlk5D2mUN4z1O5RM8capIXRLgzalTK/9DTRjFS6mmglxB9kYviK4S2/kwVgycJeDHcv+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vhIIr3ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vhIIr3ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4BFC4AF0E;
	Tue, 27 Aug 2024 23:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802158;
	bh=qC+4ew/VxVYwZ7kRBVFcHvdv4M2mK3ga/Tc4A5849qI=;
	h=Date:To:From:Subject:From;
	b=vhIIr3ZKOk15xSJmo8Nb0rdx3FuxSF6u6OrO7qN4imIOPIaffCIyTH5UNw1uwljfU
	 jbHEeIzg9h/zbB8iqh6A1ZYCTFVxTvtZi5PhzXpOrz1fpIcHf/yGDE3oRtn4s1/K4Y
	 z60NEsiI+kALqwACEGWUk8lLYLKx4mjD8tkOIQVw=
Date: Tue, 27 Aug 2024 16:42:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-make-use-of-str_false_true-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20240827234238.5F4BFC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nfs make use of str_false_true helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nfs-make-use-of-str_false_true-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-make-use-of-str_false_true-helper.patch

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
From: Hongbo Li <lihongbo22@huawei.com>
Subject: nfs make use of str_false_true helper
Date: Tue, 27 Aug 2024 10:45:17 +0800

The helper str_false_true() was introduced to return "false/true" string
literal.  We can simplify this format by str_false_true.

Link: https://lkml.kernel.org/r/20240827024517.914100-4-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4xdr.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4xdr.c~nfs-make-use-of-str_false_true-helper
+++ a/fs/nfs/nfs4xdr.c
@@ -3447,7 +3447,7 @@ static int decode_attr_link_support(stru
 		*res = be32_to_cpup(p);
 		bitmap[0] &= ~FATTR4_WORD0_LINK_SUPPORT;
 	}
-	dprintk("%s: link support=%s\n", __func__, *res == 0 ? "false" : "true");
+	dprintk("%s: link support=%s\n", __func__, str_false_true(*res == 0));
 	return 0;
 }
 
@@ -3465,7 +3465,7 @@ static int decode_attr_symlink_support(s
 		*res = be32_to_cpup(p);
 		bitmap[0] &= ~FATTR4_WORD0_SYMLINK_SUPPORT;
 	}
-	dprintk("%s: symlink support=%s\n", __func__, *res == 0 ? "false" : "true");
+	dprintk("%s: symlink support=%s\n", __func__, str_false_true(*res == 0));
 	return 0;
 }
 
@@ -3607,7 +3607,7 @@ static int decode_attr_case_insensitive(
 		*res = be32_to_cpup(p);
 		bitmap[0] &= ~FATTR4_WORD0_CASE_INSENSITIVE;
 	}
-	dprintk("%s: case_insensitive=%s\n", __func__, *res == 0 ? "false" : "true");
+	dprintk("%s: case_insensitive=%s\n", __func__, str_false_true(*res == 0));
 	return 0;
 }
 
@@ -3625,7 +3625,7 @@ static int decode_attr_case_preserving(s
 		*res = be32_to_cpup(p);
 		bitmap[0] &= ~FATTR4_WORD0_CASE_PRESERVING;
 	}
-	dprintk("%s: case_preserving=%s\n", __func__, *res == 0 ? "false" : "true");
+	dprintk("%s: case_preserving=%s\n", __func__, str_false_true(*res == 0));
 	return 0;
 }
 
@@ -4333,8 +4333,7 @@ static int decode_attr_xattrsupport(stru
 		*res = be32_to_cpup(p);
 		bitmap[2] &= ~FATTR4_WORD2_XATTR_SUPPORT;
 	}
-	dprintk("%s: XATTR support=%s\n", __func__,
-		*res == 0 ? "false" : "true");
+	dprintk("%s: XATTR support=%s\n", __func__, str_false_true(*res == 0));
 	return 0;
 }
 
_

Patches currently in -mm which might be from lihongbo22@huawei.com are

lib-string_choices-add-str_true_false-str_false_true-helper.patch
mm-make-use-of-str_true_false-helper.patch
nfs-make-use-of-str_false_true-helper.patch

