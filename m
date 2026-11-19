Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066114;
	b=sGI/9wKK2aON5Ex3TyK+ripj27+wkginYUKR3aFQTIPQj5UdO4HXibv+EbZGRkiMaHCA
	 cwIghFwwBIGeZfwrMSOPypojwObXXVviyP4Y6NMA2vHTf3a62cGyZ0nZkLOMEkou22spd
	 cOJ/95z3k808HQUnPmvBxoJGlvYNbGbosXE0F1u/7kKaBW2PWn3qa//9FkGlYHpkyyG8O
	 amrLtn26VnI8G0HKF3PlEOdqNd4lGqtcwBznbfdPk0oetrvile1NKuqI81h8epAyjxN+I
	 h+FJ9KKhZO/bbHY/0mrB4QAllWjPkeYG3Gw22z3CLgrHLc+RWNZLZDF/r8XYDfhidqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066114;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=tDQ1OjHKfX/ab8f53tCKoWZ8nLlln2af4EdAblFrEL4=;
	b=pAEnku+jtUiqKhJMryDJV9Jv7XsDu3NSfRKG+5lLoLLAOvXrJjg+KRgIRKW8kA4NP6Xj
	 p+KXqPsg6lMTQc5nvWK4NFn+9DA6c3s/69faWUsSSpSdxpfMWM0kg/AGTBuQjnVNhEn/3
	 tmG2XUipRUGsU451bl2LL9Y4s06T6pyTX+JSa8NCK0MH9L6OhYP/+Sr7Trd0m9067AV/P
	 pM6kzYCOev0kYBETtCIo8tMcZkv/V+6AsbvTQlFrtnyLca4mXtOWwLV3VaLc9ekmCqQar
	 BQL954Zr1Gv2gSxaOHFhpPMYsWMC3QrB4cQJJiIunmbK1NTr1hdfAR7JxH2p2RoHNQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Rm/mTrFG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B028606A325;
	Thu, 19 Nov 2026 05:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Rm/mTrFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C5B1F000C4;
	Thu, 19 Nov 2026 05:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795066114;
	bh=tDQ1OjHKfX/ab8f53tCKoWZ8nLlln2af4EdAblFrEL4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Rm/mTrFGNT4TMB3JypZOD73ie2cmVkga08N8CQ5Rs83lk319hPgU2pDgQNXELUswT
	 g02T20Yemu7J+AGDTZmGp1S2kI203qEp0c5kIU11zo8Yo9QOfalONh0eP8LgqGPj9J
	 WO87dsGOvPkd38aolUNQ8B1mGzwk/4X8qLdjRAx4=
Date: Wed, 18 Nov 2026 21:28:33 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shyckless@gmail.com,
	mporter@kernel.crashing.org,kaixuan.li@ntu.edu.sg,alex.bou9@gmail.com,
	stevewong@hust.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119-rio-v1-1-3cf63c5198ff@gmail.com>
References: <20261119-rio-v1-1-3cf63c5198ff@gmail.com>
Subject: + rapidio-use-file_ns_capable-when-checking-config-space-read-access.patch added to mm-nonmm-unstable branch
Message-Id: <20261119052833.E9C5B1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: rapidio: use file_ns_capable() when checking config space read access
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-use-file_ns_capable-when-checking-config-space-read-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-use-file_ns_capable-when-checking-config-space-read-access.patch

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
From: Suyuan Wang <stevewong@hust.edu.cn>
Subject: rapidio: use file_ns_capable() when checking config space read access
Date: Thu, 19 Nov 2026 04:08:00 +0000

rio_read_config() limits reads to the first 256 bytes unless
capable(CAP_SYS_ADMIN) succeeds.  That checks the credentials of the task
doing the read, not those of the task that opened the file.

The config attribute is mode 0644, so any user can open it.  If such a
descriptor is later read by a task that has CAP_SYS_ADMIN, the read covers
the full maintenance space.  The allowed range follows whoever happens to
read the descriptor instead of the credentials it was opened with.

Use file_ns_capable() with init_user_ns so the check is made against the
credentials saved in the file at open() time.  A descriptor opened without
CAP_SYS_ADMIN then stays limited to 256 bytes whoever reads it, and a
privileged opener can still hand the descriptor to another task.

This matches pci_read_config() in PCI sysfs, and the PCI procfs change in
commit f82f53e75eff ("PCI/proc: Use file_ns_capable() when checking config
space read access").

Found with a static analysis tool and checked by hand.

Link: https://patch.msgid.link/20261119-rio-v1-1-3cf63c5198ff@gmail.com
Fixes: 394b701ce4fb ("[PATCH] RapidIO support: core base")
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <shyckless@gmail.com>
Cc: <stable@vger.kernel.org>

 drivers/rapidio/rio-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rapidio/rio-sysfs.c~rapidio-use-file_ns_capable-when-checking-config-space-read-access
+++ a/drivers/rapidio/rio-sysfs.c
@@ -123,7 +123,7 @@ rio_read_config(struct file *filp, struc
 	u8 *data = (u8 *) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN))
+	if (file_ns_capable(filp, &init_user_ns, CAP_SYS_ADMIN))
 		size = RIO_MAINT_SPACE_SZ;
 
 	if (off >= size)
_

Patches currently in -mm which might be from stevewong@hust.edu.cn are

rapidio-use-file_ns_capable-when-checking-config-space-read-access.patch

