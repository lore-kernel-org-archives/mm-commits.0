Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375899;
	b=sqBFYGdHHZRPGF0XKClpi+QA8fxeff9Y+JxplcYLzCmECbI5ul+3uvhiKOwiq3yuaRR2
	 eDNTco48P1bsacBbkgFSHqIZmDv5cJI9UhK4pG/l/0AhBLdlUOqkV0j6qGV4YF/mPGfiI
	 VIOAzNiZu8pHTMSqoy6+iDECLX6bO8VVICwGUv9yI+EyJ+is4t1BUzMPhGM1+GNxr6VEm
	 dLXPJebrix+LMhhBTo/X8vPB2VZnbNHBca+AORpzt04RNzFgSUQQdY24CH2lI9TFQvTpi
	 43R0gPqr8fg/7yQNXa2jjdtEA6FltsB3mhCKzJFO0ta8uxnYcNXXt7K/0QAvhVlwe4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375899;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IDAM2ZkpLDVsarpG9eiDh88MXkTRZEShe7sztPAAF4k=;
	b=i7f0RZwXk7HlRIAz09tf7BRKjbiMgLi8KRtZnlfHXYvTyDRSgYWpMdRzGgOnirzzKczw
	 G0lJbx/lFXHpC4PZPReD8dHBTx8wiLuJUDQ+tK/LW4P6kJ6ah3wEvMn/E15qi7mL5yz/K
	 UyC9esOVLXed9MCqo9ME4HWpJQB/3x7JkFwt7U+qv2REdZo+VmxnGLmSmUsDUoAOGp7Fc
	 irxPrXy8RiWNo4uEXehUBNOhJZzPXvL52N7Mg/919qWFgFCpfVOlVog5k1rWvORj7c01a
	 gxbPWfhTbWKLTpdpjJ0hXC7GelIF36xs1Cd+Ec+8dDcwATRFs6L+j1Gvni+qyqA6SjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hX8il7IE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94042606A31A;
	Fri, 30 Oct 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hX8il7IE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F2D1F000C1;
	Fri, 30 Oct 2026 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793375899;
	bh=IDAM2ZkpLDVsarpG9eiDh88MXkTRZEShe7sztPAAF4k=;
	h=Date:To:From:Subject;
	b=hX8il7IEuSEkOmU1JKR4lp5ap1Wl27E2xIYMNQImtEAbRlSO63gBWX9BEQo1hr3p+
	 7+GsDoNdes5B2dAYTKwHoQNGXrFVBkTBLmJn7QowEtIa1DJmbVyQ3O+ee6nzJ1MbGu
	 GsQlAioB/+SE39kbGQicRN/j0mZtkoBY6xhlNwdU=
Date: Fri, 30 Oct 2026 08:58:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashal@kernel.org,
	joe@perches.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261030155819.12F2D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: get_maintainer: lazy load JSON::PP only when --json is used
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_maintainer: lazy load JSON::PP only when --json is used
Date: Fri, 30 Oct 2026 16:43:48 +0100

After commit 09d8b39563e8 ("get_maintainer: add --json output mode"),
I can no longer use get_maintainer.pl; it fails at compile time if
JSON::PP is not installed even when --json is not requested.

This module is only needed with the --json option. Use "require" to
load this module dynamically inside the "if ($json)" block instead.

Link: https://lore.kernel.org/auS7NOsyw7pJ7rbF@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: <stable@vger.kernel.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/get_maintainer.pl~get_maintainer-lazy-load-json-pp-only-when-json-is-used
+++ a/scripts/get_maintainer.pl
@@ -21,7 +21,6 @@ use Cwd;
 use File::Find;
 use File::Spec::Functions;
 use open qw(:std :encoding(UTF-8));
-use JSON::PP;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -685,6 +684,7 @@ if ($json) {
     $result{web} = \@web if ($web);
     $result{bug} = \@bug if ($bug);
 
+    require JSON::PP;
     my $json_encoder = JSON::PP->new->canonical->utf8;
     print($json_encoder->encode(\%result) . "\n");
 } else {
_

Patches currently in -mm which might be from oleg@redhat.com are

get_maintainer-lazy-load-json-pp-only-when-json-is-used.patch
proc-use-pid_has_task-in-proc_inode_is_dead.patch

