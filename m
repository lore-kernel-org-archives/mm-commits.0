Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABAE43DED9
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865925; cv=none; b=uoWG+5bhJwMDblPQdg/H9fabVZgdeCTJZllR2Usr+coUdsfoC7FDo/txK23/vmBDcrsIqk2QZFLYjMajaUMZbo46ZQLgsGTtz7Dw/hfDL4HKSiF5k29cB5PU50vNHSpaXWjEEPxnKhdsAnNlpF/mz2aDGg0J/a3If0aoMrUIGKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865925; c=relaxed/simple;
	bh=/jliN9S1/DWcZy39vREP2+8r7Makk7AwObllu9AR0HQ=;
	h=Date:To:From:Subject:Message-Id; b=tNI4kkbJ1IkR8cmab3BJnUujVd4MoBTEjtfuZ114sATletFCrHyd7PPBINsOPSFWAgqptq919jEvBs016xU88oey5e03qpmEB9g4cvdrY76lrk9OoW/QfDJdOqWutif9g8D3/fyjRuChrG1iBRLELw/BWb3jydIsTsdDPHW7pbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JK6+fDzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JK6+fDzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077BD1F000FF;
	Tue, 13 Oct 2026 04:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865924;
	bh=IqzFs7TfwcuYLs163tcGG+u8BolfVOUtvO1jMhS2H7o=;
	h=Date:To:From:Subject;
	b=JK6+fDznsIoyKKF1JxvKkNScI3skRdWfNHexPz/roa+ryQwuzaSCXtOwVIBP3hEZS
	 +9y+6p0KWAjC4WxMrHg8o8d7RgBYoaq7oXmvY5DiJ37nddCKbCqCo7K82KXe/Jsdj4
	 pLvfUpxLkYspxg/uRp/KwCsktv48xRiVGctI5sw0=
Date: Mon, 12 Oct 2026 21:32:03 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-fix-the-enable-parameter-description.patch removed from -mm tree
Message-Id: <20261013043204.077BD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/secretmem: fix the enable parameter description
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-the-enable-parameter-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/secretmem: fix the enable parameter description
Date: Sat, 12 Sep 2026 13:48:59 +0200

The module parameter is enable, but its MODULE_PARM_DESC() names the
variable behind it, secretmem_enable.  secretmem is built in, so the
description only reaches modules.builtin.modinfo, where it is filed under
secretmem_enable while the parmtype line and
/sys/module/secretmem/parameters/ say enable.

Use the parameter name in the description.

Link: https://lore.kernel.org/20260912114859.88957-1-kmehltretter@gmail.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Assisted-by: LLM
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-fix-the-enable-parameter-description
+++ a/mm/secretmem.c
@@ -39,7 +39,7 @@
 
 static bool secretmem_enable __ro_after_init = 1;
 module_param_named(enable, secretmem_enable, bool, 0400);
-MODULE_PARM_DESC(secretmem_enable,
+MODULE_PARM_DESC(enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
 static atomic_t secretmem_users;
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

