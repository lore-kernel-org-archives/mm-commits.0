Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BED435F17B
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772305389; cv=none; b=XucKQgiEuhLb0bwz1AvroJ3R8tNoy/vtESdxtfXAF6FknjYlJU+1eEGDbqClsrgmh6eWymj2IwphJtqui9g34hl5mivsVyHOjyyahVD9Y2vuE/lJwW75hvoRe+p7uz3+HRV1atIHdOoKoMfz27rRT1hzA8KcCfJcCz4CHd6FdI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772305389; c=relaxed/simple;
	bh=bOzdx6/9Q0XJMele6NUBd75EbP1yjUVPMNrNGVOP1wY=;
	h=Date:To:From:Subject:Message-Id; b=On1Ty/oKvcDJAAzQv5T1nSMbcTemflhnAmUp8m8wmxp//OA140f5Jrjxk47UykvMZQQlBk5ZJgjQ0KhuUD6Mjl3nvKq+anonarPeZTqGYA+T1Pe8hQQ4QPCM4kAfaHEIKDt0en5Ud8fi/SKWIeNC5Hw3MV90lsggqKgsKXN4EBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gPCobkLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gPCobkLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F42CC116D0;
	Sat, 28 Feb 2026 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772305388;
	bh=bOzdx6/9Q0XJMele6NUBd75EbP1yjUVPMNrNGVOP1wY=;
	h=Date:To:From:Subject:From;
	b=gPCobkLG3T8KKWUErULjenoFHZgJpzz5tbHNK5lLC66fXNlX1M4ELTo4UdJ3Fd6+1
	 UJ5cG9IHwtzGMhm2pM5cIU/dYstp+d9QM1pybIPuZkI4v3eU0rCQGVvQDH2lkR5jrG
	 z6kmQCA8+l+A32V8jsT8J2uc+L2wtEysZyhJaVeI=
Date: Sat, 28 Feb 2026 11:03:08 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-remove-redundant-less-than-zero-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260228190308.9F42CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: remove redundant less-than-zero check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-remove-redundant-less-than-zero-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-remove-redundant-less-than-zero-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: remove redundant less-than-zero check
Date: Sat, 28 Feb 2026 09:51:36 +0100

'key_count' is an 'unsigned int' and cannot be less than zero. Remove
the redundant condition.

Link: https://lkml.kernel.org/r/20260228085136.861971-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-remove-redundant-less-than-zero-check
+++ a/kernel/crash_dump_dm_crypt.c
@@ -115,7 +115,7 @@ static int restore_dm_crypt_keys_to_thre
 
 	addr = dm_crypt_keys_addr;
 	dm_crypt_keys_read((char *)&key_count, sizeof(key_count), &addr);
-	if (key_count < 0 || key_count > KEY_NUM_MAX) {
+	if (key_count > KEY_NUM_MAX) {
 		kexec_dprintk("Failed to read the number of dm-crypt keys\n");
 		return -1;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch
crash_dump-remove-redundant-less-than-zero-check.patch

