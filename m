Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA6313E31;
	Sat, 28 Feb 2026 19:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308342; cv=none; b=mUZIuzo/k2E3LEDWKiQwhVNEek7BgFMIHYW77VIjT44mU1WvjEu7vPetL/RDbZdGLEclFnf+5pGuTn53O2UCQ6BusqhrRPSmNRXZPTdSUB2M35Fc3IODfcO3DvJM1a00JP5rQF6p0ozrA45ar4JziHvDyu2wLgM6NplcDXL3dUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308342; c=relaxed/simple;
	bh=c2Zn/xxLojynkFcP3OA4wo7QpyGs7m+4o0ASAhCxny0=;
	h=Date:To:From:Subject:Message-Id; b=hZyFwIbftXDPvWASNJ/18+SmClFpeNyzdJZLBlMEfAbs6kQSdZZp1mW3zpRcyg1PRpiUxely1iX94bf8pFM0XFf75mPkQtHsB7jIL530yseG0mIKOws4fh2V0OqK/AenBFAwtL3Wzjw5KLe3+B48jt+soqwr7NBFSLfEo+f2ADs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LWo7Y5hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LWo7Y5hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F2CC116D0;
	Sat, 28 Feb 2026 19:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308341;
	bh=c2Zn/xxLojynkFcP3OA4wo7QpyGs7m+4o0ASAhCxny0=;
	h=Date:To:From:Subject:From;
	b=LWo7Y5hg0SyE9/xyJSA2V3UOSaqoyuZaLxkx6mpTRoCrF2v2ZrrYPREBFp77AdFAO
	 hTRpqZS+E/kyCVr3cMqcy8i5ObZfsYQomTNeD6609uRY/qIIWKPg7e6rtHTQ237Rn0
	 BrR/Mj+fVmbENiyZfk9MLZBmVbe/gGj4Lnjis0YU=
Date: Sat, 28 Feb 2026 11:52:20 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch added to mm-hotfixes-unstable branch
Message-Id: <20260228195221.90F2CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying
Date: Sat, 28 Feb 2026 00:00:09 +0100

When debug logging is enabled, read_key_from_user_keying() logs the first
8 bytes of the key payload and partially exposes the dm-crypt key.  Stop
logging any key bytes.

Link: https://lkml.kernel.org/r/20260227230008.858641-2-thorsten.blum@linux.dev
Fixes: 479e58549b0f ("crash_dump: store dm crypt keys in kdump reserved memory")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying
+++ a/kernel/crash_dump_dm_crypt.c
@@ -168,8 +168,8 @@ static int read_key_from_user_keying(str
 
 	memcpy(dm_key->data, ukp->data, ukp->datalen);
 	dm_key->key_size = ukp->datalen;
-	kexec_dprintk("Get dm crypt key (size=%u) %s: %8ph\n", dm_key->key_size,
-		      dm_key->key_desc, dm_key->data);
+	kexec_dprintk("Get dm crypt key (size=%u) %s\n", dm_key->key_size,
+		      dm_key->key_desc);
 
 out:
 	up_read(&key->sem);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch
fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch
crash_dump-remove-redundant-less-than-zero-check.patch

