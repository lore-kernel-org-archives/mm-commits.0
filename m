Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1717BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990481; cv=none; b=toowjnmexNtP3XMNA83DTqIsB0S2zRkq2dDlgj/XgMI+kP62hjpWwQEe4Gk3ODEfRoOk5GK9SkUnZh1K+xrkxBgordu5un6nNh+jmT75oDOOCzhAAiaKsyZp3cSCzwUxyXUjkMXEzktbfY4aW4nsD7DO2iUxtvjCzV8Gx3YN698=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990481; c=relaxed/simple;
	bh=U3LHueLruvlkvflZY2f1mFIgnczvBejYNBL9am8qXKA=;
	h=Date:To:From:Subject:Message-Id; b=muGpIH5EjYqX+Lz3jGsZf5/gy5FoAS6DPRsehigRlpSFj3qXCSowECAxiI0QSC7+XyU7YvQM6ALLcnogwS1Pq5EkfiY6d9Rx2D49e4XGj64zBQlFuAmJFElpuDIDakEIU0aOdTxW9kdo2mDmguLNGO7ZRp2i4nin9161xvvXTtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocZiaUJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocZiaUJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339FBC4CEE3;
	Mon,  7 Apr 2025 01:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990480;
	bh=U3LHueLruvlkvflZY2f1mFIgnczvBejYNBL9am8qXKA=;
	h=Date:To:From:Subject:From;
	b=ocZiaUJH0tPWrimWlFG7JBY9rYUAXTAESM5iqRav+lYVDeVrdfZ872CPuz3AvXR+M
	 J61UWHsGIzpRfk9i0rhwdf34kA8zv3k+x9bj4AiS+cZMyb30rRbCJ9b4nPeQWZ8DVs
	 kbkcUVUFbPYBjDF8NJpsKwRXM5sLun6HaVmOr7zA=
Date: Sun, 06 Apr 2025 18:47:59 -0700
To: mm-commits@vger.kernel.org,xiaopei01@kylinos.cn,vbabka@suse.cz,sfr@canb.auug.org.au,rmoar@google.com,masahiroy@kernel.org,linux@roeck-us.net,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exportfs-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014800.339FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exportfs: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exportfs-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exportfs-add-module-description.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: exportfs: add module description
Date: Mon, 24 Mar 2025 18:32:26 +0100

Every loadable module should have a description, to avoid a warning such as:

WARNING: modpost: missing MODULE_DESCRIPTION() in fs/exportfs/exportfs.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Cc: Rae Moar <rmoar@google.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exportfs/expfs.c~exportfs-add-module-description
+++ a/fs/exportfs/expfs.c
@@ -608,4 +608,5 @@ struct dentry *exportfs_decode_fh(struct
 }
 EXPORT_SYMBOL_GPL(exportfs_decode_fh);
 
+MODULE_DESCRIPTION("Code mapping from inodes to NFS file handles");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

