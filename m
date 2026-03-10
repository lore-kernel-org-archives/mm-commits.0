Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77166293C42;
	Tue, 10 Mar 2026 23:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183749; cv=none; b=b4g2pxTMvZIyek//wZJtjYiv+ufiemZ/SRFQGdlZbx0lOqaSBJOcncELiIOb6rBLTPFETu4tFe4BfdzIoeuddY1NWc/gH9RE6J9ipnJ95EVaaQfdFVFBryJ4vON7JUcUJAPswcJozcVoT+cnAJWnfkbemXlsplbI4RhSTUH/AD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183749; c=relaxed/simple;
	bh=8uPU0kv1B3D/QUlpGmw25z/TvKIWWjAPK3Lg8MQ52mY=;
	h=Date:To:From:Subject:Message-Id; b=rqOvvfv0k0+1iJ0fWDHGM4sYRyZItLM3pjQ5qKEgywNkbfh+DrSYOsvjUgEARZDZrK3caRZakkPgO3gFgQhgs6p6pa4Hcu7mb2nRaw0037+jjjG1UIXJdrAqGyP7xIqHiyzVUYpXU7tmDZntmz0RGImlz0/kpKugW2k7N67l4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZPyGf/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZPyGf/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37BBC19423;
	Tue, 10 Mar 2026 23:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773183749;
	bh=8uPU0kv1B3D/QUlpGmw25z/TvKIWWjAPK3Lg8MQ52mY=;
	h=Date:To:From:Subject:From;
	b=oZPyGf/DS/FQ8r7dvuoiOc54of96Bjw6FsQG/pGzUHrTp8GaiJoPgAu7HVbt+pKws
	 H41xLDfWK4k8b5HC3glK6AuZhfM3nysO4jqhf1JoRNbNcS19jnHtWmDMq/JchCLzV9
	 /K2WzOK1Uuw07xIqNy3yqNKYKpgEtEgEMzth9iz8=
Date: Tue, 10 Mar 2026 16:02:28 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch removed from -mm tree
Message-Id: <20260310230228.F37BBC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying
has been removed from the -mm tree.  Its filename was
     crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch
crash_dump-remove-redundant-less-than-zero-check.patch
crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch
crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch

