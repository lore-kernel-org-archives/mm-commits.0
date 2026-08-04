Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754D63D0932
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816288; cv=none; b=oV4Ot5jrqn2IpZML19fnc4AlPG1+9R9JCdQMu/l0di92mifDEqHmDj7gxIVjj/TYZav4o3ztAO2Zy0x2PGW3ybpb+VJf1QRghwCfrg7WlHyy3BYkRocB3+MVmPTGLdF8T+9e7Ef2v3eDcwWrS8EbQvegli3oMcVusw8xaaPkDx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816288; c=relaxed/simple;
	bh=kNqu2Q2/pV0Nv+/Uk/0T845CD4tBM9zYQyum++zJmrQ=;
	h=Date:To:From:Subject:Message-Id; b=XUPB6N18WDeNz7k0f1+sLd5vyllaf/Dj5B4ePHu+3iy8gTqkF8nXQMN7ewlpQh7cazFZv81Y83HWxOXJzel972XUjlT969tBWclTeofRwTQMZbunPInr88ul6jGLUvS3D/dbbIx6v5uPWxrv7MecLBdvQfYfKfGJ6RwP0DOoHAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DES6yCu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DES6yCu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED61F000E9;
	Tue,  4 Aug 2026 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816287;
	bh=5FGfpqp5bqzza0ptL8EJcZual1ooWBy4moQj9hjUaQU=;
	h=Date:To:From:Subject;
	b=DES6yCu/L+Ze67oaKLP3iqyCaRMFvYC7g27EkPzEmn46hQyCeqkPHrDstfxvNGNSW
	 x0GydNJHgKNFrDhTiI2GANN/+rXrZO0Rqka0YIqkvGcYH7DL9k518+CHPIMVG3Qxtd
	 tMAj5+fJk9JZ6qcAb24oibW7+n6O9VBA6p8TZijE=
Date: Mon, 03 Aug 2026 21:04:46 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-params-fix-a-pr_debug-%p-in-parse_one.patch removed from -mm tree
Message-Id: <20260804040447.29ED61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/params: fix a pr_debug(" %p ") in parse_one()
has been removed from the -mm tree.  Its filename was
     kernel-params-fix-a-pr_debug-%p-in-parse_one.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kernel/params: fix a pr_debug(" %p ") in parse_one()
Date: Thu, 18 Jun 2026 13:07:15 -0600

Inside parse_one(), the core parameter-parsing engine prints the address
of the parameter-set callback function using %p: pr_debug("handling %s
with %p\n", param, params[i].ops->set);

Since the string value of the parameter being parsed (val) is already
available, print the parameter name and its value instead, and avoid
tainting the kernel by exposing a kernel-ptr.

Link: https://lore.kernel.org/20260618190715.3563047-1-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/params.c~kernel-params-fix-a-pr_debug-%p-in-parse_one
+++ a/kernel/params.c
@@ -136,8 +136,8 @@ static int parse_one(char *param,
 			if (!val &&
 			    !(params[i].ops->flags & KERNEL_PARAM_OPS_FL_NOARG))
 				return -EINVAL;
-			pr_debug("handling %s with %p\n", param,
-				params[i].ops->set);
+			pr_debug("handling %s with value '%s'\n", param,
+				val ? val : "no-arg");
 			kernel_param_lock(params[i].mod);
 			if (param_check_unsafe(&params[i]))
 				err = params[i].ops->set(val, &params[i]);
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


