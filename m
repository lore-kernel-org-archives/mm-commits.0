Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F515C158;
	Thu, 12 Jun 2025 05:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706987; cv=none; b=FgrVFcpnZw2toj9116V+N3Sdd8K4pztDoPKIYh+5Q1sayfClpPNzYWKdkJJfpaRBa7RXmmK4jogV6rTOtVOxWdSRT7gOD+XIDpghT5UxN6BR7oBvHCF3n40arPkOnQLRxzpqTGxVeyRYEHx7NSrD8loA3LafUr8NOLEmqDoA4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706987; c=relaxed/simple;
	bh=IawCyzg+OcwabZuRtL2PDmuB7665zcv0zXgKW3pMCe8=;
	h=Date:To:From:Subject:Message-Id; b=YwJ+58SbfBwejBnLELwZ7iE6w66dGSpzE1AyRDqN0jr1OAjPS3S9t/OjmzMCser9fZXHTHMl7jA+emNVR6bz1iYWdkOgelOtJ7auGvsviQcUM/W1n1X2GtEGax074M7JzyTxjTbUD2Rmjg0RA79k/Oo2UADTaVorVxMl7sjWaoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EpriXUtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EpriXUtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD98C4CEEA;
	Thu, 12 Jun 2025 05:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706987;
	bh=IawCyzg+OcwabZuRtL2PDmuB7665zcv0zXgKW3pMCe8=;
	h=Date:To:From:Subject:From;
	b=EpriXUtNP1r4TGif+VvsMBmWYz+OLsQyxVG5UlT8tlqPP1ulOllEmIz8Ycakjp0Sm
	 nz8P7HX0+ItD/81jM/Jr4sfEIXtkOVvXHOaBqh5eGRX3+/Ci+JJ7eRRLfEfeO42qHi
	 o/tba/djcFlyl4SsoUnpq3aafQq1ikTXW2Gdm0JI=
Date: Wed, 11 Jun 2025 22:43:06 -0700
To: mm-commits@vger.kernel.org,torvalds@linuxfoundation.org,stable@vger.kernel.org,mporter@kernel.crashing.org,maherazz04@gmail.com,alex.bou9@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch removed from -mm tree
Message-Id: <20250612054307.1FD98C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/rapidio/rio_cm.c: prevent possible heap overwrite
has been removed from the -mm tree.  Its filename was
     drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rapidio/rio_cm.c: prevent possible heap overwrite
Date: Sat Jun  7 05:43:18 PM PDT 2025

In

riocm_cdev_ioctl(RIO_CM_CHAN_SEND)
   -> cm_chan_msg_send()
      -> riocm_ch_send()

cm_chan_msg_send() checks that userspace didn't send too much data but
riocm_ch_send() failed to check that userspace sent sufficient data.  The
result is that riocm_ch_send() can write to fields in the rio_ch_chan_hdr
which were outside the bounds of the space which cm_chan_msg_send()
allocated.

Address this by teaching riocm_ch_send() to check that the entire
rio_ch_chan_hdr was copied in from userspace.

Reported-by: maher azz <maherazz04@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rapidio/rio_cm.c~drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized
+++ a/drivers/rapidio/rio_cm.c
@@ -783,6 +783,9 @@ static int riocm_ch_send(u16 ch_id, void
 	if (buf == NULL || ch_id == 0 || len == 0 || len > RIO_MAX_MSG_SIZE)
 		return -EINVAL;
 
+	if (len < sizeof(struct rio_ch_chan_hdr))
+		return -EINVAL;		/* insufficient data from user */
+
 	ch = riocm_get_channel(ch_id);
 	if (!ch) {
 		riocm_error("%s(%d) ch_%d not found", current->comm,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch

