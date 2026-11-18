Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980534;
	b=yi5bNlrjNZWpm+K01QV7qXAdeNYXOd3OZ1TUuFbtrEzc1NUpf1PqXRXZCQcYMJu+OVTv
	 sOVRgHz+7uJ3mu+QYdyL8JBKvJyTg+LlpN4SrzzfQxeTN5AUc/BLU2rNvqtZbLMVet1+5
	 gIKiVxOfGVQNBF3xCY17D/zz4w2gnep5aB6BfdoE2YjamoR2Y7rRieXMGTyuI2MvakHTY
	 X+8D6qEieUNxOxa421sBXy0VlHWi1E4fT74C+lwb8MKnB18YViWH2s1wpx+X9TlH45ksj
	 +jchMu/iNXWw+dHUAaRaqyh84krCVide7jebFafF87+qOJy7rxc3S7II/2hqgpJ86pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980534;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=P5s7B7MrnIxgT5Wzm9VvhkvxphOpYmnbyJWAqylOT0s=;
	b=3p1siuTqk4OE7sh2uZJ120n0YEMaXu9I5txXaqmYVo7YJZFZ2KC/Cp8asKmnjkioolj6
	 BttpihGa/QakeAJKut0wZfPpOqWmKYkkXvl2bttY10SLO0gedt66USQmx9MPAybarN0h4
	 6Tc4i0iHDB43k4FoE3zVDo9Pc0iePCby6MXuAASId7i01cvcNGWbCEHne+GrQ8uvnqY4v
	 QilexeserUNSgnrUKZKIuoR03tsoD07znOzM9SsipvtDWAmMU0SJNtu2xZ/N9TFWfTy7O
	 VIAIWonu9LmLM6KrEU760Lx1CiSFlUYAydWK3KJEEFf/vK64Mi2ySOtt/kG/D+GcbHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EvGBKBBT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C1B606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EvGBKBBT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF511F000C4;
	Wed, 18 Nov 2026 05:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980534;
	bh=P5s7B7MrnIxgT5Wzm9VvhkvxphOpYmnbyJWAqylOT0s=;
	h=Date:To:From:Subject;
	b=EvGBKBBTWECMkTA8ypBB1ea5O9O0Td9IWnEGkhAeRpuAUVQpnUdLKC6Cix3/RZbns
	 XUaEDJlg73di32jYumqdfqy6RhcE4Kf1zY+syFPeZoXlVG+TQPWFtq3Kk5rATBBkBb
	 mydigvm2jrk6HBh4NVAlib9CIOAfKev2ELmsUJbs=
Date: Tue, 17 Nov 2026 21:42:13 -0800
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,mripard@kernel.org,
	maarten.lankhorst@linux.intel.com,bp@alien8.de,joe@perches.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] maintainers-drm-drivers-and-misc-gpu-patches.patch removed from -mm tree
Message-Id: <20261118054214.0FF511F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES
has been removed from the -mm tree.  Its filename was
     maintainers-drm-drivers-and-misc-gpu-patches.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES
Date: Sun, 01 Nov 2026 00:41:12 -0700

There's a small defect in get_maintainers.pl that allows
incomplete file pattern matching.

Update the "F: include/drm/drm pattern" to specify only the actual files
covered instead of a prefixed partial path to these .h files.

Link: https://lore.kernel.org/576e04e1d8f0d5ac0805d450b9c87e69f7f0d2c8.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Borislav Petkov <bp@alien8.de>

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-drm-drivers-and-misc-gpu-patches
+++ a/MAINTAINERS
@@ -8883,7 +8883,7 @@ F:	Documentation/devicetree/bindings/gpu
 F:	Documentation/gpu/
 F:	drivers/gpu/drm/
 F:	drivers/gpu/vga/
-F:	include/drm/drm
+F:	include/drm/drm*.h
 F:	include/linux/vga*
 F:	include/uapi/drm/
 X:	drivers/gpu/drm/amd/
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainerpl-fix-inexact-file-pattern-matching.patch

