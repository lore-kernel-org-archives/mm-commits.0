Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779AA144D0A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248850; cv=none; b=BNYTrPJaXNrey5GyDsCI11xSOe+jhA0ANktoA/c6Qo1YyTLQhVIKzZCCLnLjDyxrTmRABpAwM8H/C+lmhho0GZzdLnLQ0BWCd86myipe+KEGNnEBxxbCsq8YJd4TrxFv2qz6cff+A7fxCOCC0wqujFFEXbKbinvvxowgLPxq4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248850; c=relaxed/simple;
	bh=fz9JlU9ZWW9NHkeXoC29zXZdX676jAGrftLs5FyWFLA=;
	h=Date:To:From:Subject:Message-Id; b=gCkkD7Wzrz61+OSA6R9mvAmthMHlMYXJ5cz7vPBqZ+qPK4uW+UQXrhGS8rsM/YYXosFgxy4lVYg2Qd6BYzNW1+BxhTEpVApX9jNkcMKIwA6eKrC2qz/eYV9l+bGMk7A7dcAPM9A4AE/gbFD08g4kK4u6ombATCukl2N4L4FcwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j1jhA33j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j1jhA33j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F775C4CEC2;
	Mon,  2 Sep 2024 03:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248850;
	bh=fz9JlU9ZWW9NHkeXoC29zXZdX676jAGrftLs5FyWFLA=;
	h=Date:To:From:Subject:From;
	b=j1jhA33jFRhK6kQ4TXQtdexbJPvgAMFoLu9OcgV3dJeHyS/CLFkywdJAWkSspajEn
	 YQsjHkBJY9Krag2vPeAG5dlZDiXHJ5J+50W2z/sxqT0JekGoviCoBqbpUMRap11Ou2
	 X8egDaBpKGPr2caeD4lY5ygEw+3jKuWhvva1E/9o=
Date: Sun, 01 Sep 2024 20:47:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,trondmy@kernel.org,kees@kernel.org,gregkh@linuxfoundation.org,anna@kernel.org,andy@kernel.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nfs-make-use-of-str_false_true-helper.patch removed from -mm tree
Message-Id: <20240902034730.4F775C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nfs make use of str_false_true helper
has been removed from the -mm tree.  Its filename was
     nfs-make-use-of-str_false_true-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-make-use-of-the-helper-macro-list_head.patch

