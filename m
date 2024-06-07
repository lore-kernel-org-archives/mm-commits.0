Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6414EC46
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792273; cv=none; b=oz5Z7zvOuFNrelMmFMSFYmW6MeeRc25TeaGfMHcs18RbKYI9IS3WRlA1vhk1WlMsA5FaITOPT0agQFQqBxKk2TwKNn3yEFBe7oG3vUhGttWG94/zw5gx02rt9b62ck5kIP+vhLOb2cR4KC4jCWZspd/xIhbc4jMYhHXZ1Stm9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792273; c=relaxed/simple;
	bh=u++KhQERLboYkcSAcfRLAhvnWAxF0LOsH8/rZzFIOxY=;
	h=Date:To:From:Subject:Message-Id; b=TTobHlyBAst3425crkSSak1xNc39cEtN8PmVmQzAEZ4UfjpmnZGODUyLZExOUOS5TAP191symckHfIphisceCeOPFKM6Xcs627mPOj2A0oItL4Ja70UHSccTFT/aqgd6/jVFYmRPYV0K2tfSrmja34cxSSG1hsyXish6prTXZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pASTA40e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pASTA40e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E759C2BBFC;
	Fri,  7 Jun 2024 20:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717792273;
	bh=u++KhQERLboYkcSAcfRLAhvnWAxF0LOsH8/rZzFIOxY=;
	h=Date:To:From:Subject:From;
	b=pASTA40eo2ulMXDRP+LQ4+z2ahY+vnAOMqcQgNyGpogcpExIolcKzLKfO0wTQsTeM
	 4822gN28/1JwknL42oiDDYWzDhjh2XmOyirzU+whY/8ZwiIj+ySwIpjT11OPViheMK
	 ocHgHUhdn3nQQ/5tQkbLjWPPhiy75uCUBGMn/xr0=
Date: Fri, 07 Jun 2024 13:31:12 -0700
To: mm-commits@vger.kernel.org,swarupkotikalapudi@gmail.com,shuah@kernel.org,lkp@intel.com,javier.carrasco.cruz@gmail.com,hughd@google.com,adobriyan@gmail.com,amer.shanawany@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-remove-unreached-code-and-fix-build-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20240607203113.1E759C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: proc: remove unreached code and fix build warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-remove-unreached-code-and-fix-build-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-remove-unreached-code-and-fix-build-warning.patch

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
From: Amer Al Shanawany <amer.shanawany@gmail.com>
Subject: selftests: proc: remove unreached code and fix build warning
Date: Mon, 3 Jun 2024 14:42:20 +0200

fix the following warning:
proc-empty-vm.c:385:17: warning: ignoring return value of `write'
 declared with attribute `warn_unused_result' [-Wunused-result]
  385 |                 write(1, buf, rv);
      |                 ^~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20240603124220.33778-1-amer.shanawany@gmail.com
Signed-off-by: Amer Al Shanawany <amer.shanawany@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202404010211.ygidvMwa-lkp@intel.com/
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-remove-unreached-code-and-fix-build-warning
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -381,9 +381,6 @@ static int test_proc_pid_statm(pid_t pid
 
 	assert(rv >= 0);
 	assert(rv <= sizeof(buf));
-	if (0) {
-		write(1, buf, rv);
-	}
 
 	const char *p = buf;
 	const char *const end = p + rv;
_

Patches currently in -mm which might be from amer.shanawany@gmail.com are

selftests-proc-remove-unreached-code-and-fix-build-warning.patch

