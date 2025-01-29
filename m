Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11562168B1
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 03:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738122874; cv=none; b=Sa1dH26VuwuZVyxpiFIChKJXqSsJfECL/NbZK4Motn024tJ4WPxrsDtrorsBODnQxHmQRho353xxSmnG/PkewZv2WkYYqeIbwGM9JtRLY3GlR6zOMgEhGzOLuDTXc285D32Os8O4oomMLsEFHjJYcGNjC+jjGVrrcZzSmk9XdOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738122874; c=relaxed/simple;
	bh=9yMIkXUW8wr5QYAdVCXi8UC2r0ikkZGaXrF9nG6F614=;
	h=Date:To:From:Subject:Message-Id; b=kG8FWZy2HpTvyPSJtiPNmIt5B48P0NnfCRUvg/ti6maayUp929VJoIpJH6W/OtZ38nMYBy/Bs7NJ4yFftLsP5MC2HWhC80pUK0z2dFb6dfAwfIX68fVCDDDU5yoJxhRFx4HkquJBGIGmr5f8JTtCWvrMFXeyrV6fBECZI9aPmJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oQKMH+Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oQKMH+Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C12C4CED3;
	Wed, 29 Jan 2025 03:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738122873;
	bh=9yMIkXUW8wr5QYAdVCXi8UC2r0ikkZGaXrF9nG6F614=;
	h=Date:To:From:Subject:From;
	b=oQKMH+Gh/iD1aJj3jF9uyzrWb+lt7cBUxqUjmq7rXbA8z65lehAQacNfzKmz3FwWm
	 XPlUg3MOXGYHh5hFpkCaS7aYhPM5nhEF5GJNj2O5E4IMLXhCWcHtfZ3TQpkLS4LZRb
	 qRh24BqkFrkjoR3i5Tg3mCcw33Cwop4z1eXxoYmM=
Date: Tue, 28 Jan 2025 19:54:32 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tytso@mit.edu,nhorman@tuxdriver.com,mcgrof@kernel.org,linf@wangsu.com,kees@kernel.org,jirislaby@kernel.org,j.granados@samsung.com,jack@suse.cz,gregkh@linuxfoundation.org,brauner@kernel.org,nicolas.bouchinet@ssi.gouv.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sysctl-fix-underflow-value-setting-risk-in-vm_table.patch added to mm-nonmm-unstable branch
Message-Id: <20250129035433.55C12C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sysctl: fix underflow value setting risk in vm_table
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sysctl-fix-underflow-value-setting-risk-in-vm_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sysctl-fix-underflow-value-setting-risk-in-vm_table.patch

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
From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Subject: sysctl: fix underflow value setting risk in vm_table
Date: Wed, 15 Jan 2025 14:22:09 +0100

Commit 3b3376f222e3 ("sysctl.c: fix underflow value setting risk in
vm_table") fixes underflow value setting risk in vm_table but misses
vdso_enabled sysctl.

vdso_enabled sysctl is initialized with .extra1 value as SYSCTL_ZERO to
avoid negative value writes but the proc_handler is proc_dointvec and not
proc_dointvec_minmax and thus do not uses .extra1 and .extra2.

The following command thus works :

`# echo -1 > /proc/sys/vm/vdso_enabled`

This patch properly sets the proc_handler to proc_dointvec_minmax.  In
addition to .extra1, .extra2 is set to SYSCTL_ONE.  The sysctl is thus
bounded between 0 and 1.

Link: https://lkml.kernel.org/r/20250115132211.25400-3-nicolas.bouchinet@clip-os.org
Fixes: 3b3376f222e3 ("sysctl.c: fix underflow value setting risk in vm_table")
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Lin Feng <linf@wangsu.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Neil Horman" <nhorman@tuxdriver.com>
Cc: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Cc: Ted Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

_

Patches currently in -mm which might be from nicolas.bouchinet@ssi.gouv.fr are

coredump-fixes-core_pipe_limit-sysctl-proc_handler.patch
sysctl-fix-underflow-value-setting-risk-in-vm_table.patch

