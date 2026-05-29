Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79911371CE0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028460; cv=none; b=WR7x5AOjMileVAMLMc1/Z6Yh+WCcTaheLMqzt49pWHpzFPYZt2hHd42KrCVG0v0DmdORrGsDBzK4P7EeMTXb+CQ3Dz8cbzAEd7qzigiBY6eLMwuUOhVOkJ9swgUHhIpGM7i6vIPZdiR0Krhey9+5LNYGLVu5KtLV7QRBL3RKHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028460; c=relaxed/simple;
	bh=sVi6ow4Wbdzg31ug8coyXmKbTYgmCvQAGu0Rq0DcDtA=;
	h=Date:To:From:Subject:Message-Id; b=X1w0B96O/3hMeE8uQjzPydN9rGq3eO4S/1m8wgyifRZ0v3DpvAKxCfAo2Mw7cNAudDczZjqtJ5Ei8RUCI/xOvLMzxaDWmUgQn0i9u4nkdd70X6i1QNnOFydm4n4XddhMeu/Uj4O3SBsMq1Lth3RBw1GHIjGNBffThs4faFX96R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y0IMnlLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y0IMnlLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB5C1F00893;
	Fri, 29 May 2026 04:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028459;
	bh=9nqE/d2lurqPFJGZgQBx/KTPBFrmaNagx+/yx5LNV9s=;
	h=Date:To:From:Subject;
	b=y0IMnlLPlmZoQTB1hdcanRCVyTsVh4pdi/YkfNG2aLDBrybhjuIq2O/nwoEJvFMeZ
	 nViUIl94/2qdgQalxilbrmmjn+7seotYQYRdUJRjAok6asZMn+V3BrpSqNqlgDt0H8
	 UyNiFZqQ2v7SXgM+EzxkABLw6g5aU67US/8qjIPo=
Date: Thu, 28 May 2026 21:20:58 -0700
To: mm-commits@vger.kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-rewrite-next_tgid-fix.patch removed from -mm tree
Message-Id: <20260529042059.0DB5C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-rewrite-next_tgid-fix
has been removed from the -mm tree.  Its filename was
     proc-rewrite-next_tgid-fix.patch

This patch was dropped because it was folded into proc-rewrite-next_tgid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-rewrite-next_tgid-fix
Date: Thu Apr 23 06:52:34 AM PDT 2026

remove newline

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/base.c~proc-rewrite-next_tgid-fix
+++ a/fs/proc/base.c
@@ -3546,8 +3546,7 @@ struct tgid_iter {
 	struct pid_namespace *const pid_ns;
 };
 
-static
-struct tgid_iter
+static struct tgid_iter
 make_tgid_iter(unsigned int init_tgid, struct pid_namespace *pid_ns)
 {
 	return (struct tgid_iter){
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcgv1-dont-compile-swap-functions-when-config_swap=n.patch
mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

