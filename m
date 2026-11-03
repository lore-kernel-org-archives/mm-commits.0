Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675988;
	b=3UBBfqP85gXM3uy6vDQV3QLczUwvuj6m9a3vNTgyn5Z6KzGWH6QFIDFMvgZlOZve+ThM
	 JwSSroKxhoMCb2YLHI1nx8emxj7JOSfnrxkgZ/hxewg4fAtb3CB3XOMSrCKDcMzHMBvif
	 Tr/5i1sMUicIC4pK8gKJbTTdRGUooGziQdaUDPLO9BL5AKz2pZctQI2nRflxjAPhwdvKz
	 5apBmHnWPx/99uXUFTWuBRQB8nvygUxCIHOdzr32JDNC+cu+ykfnoxCekAsYj16k5ZkGj
	 JJndHXU0eJaEpvVSPiJpvPDts/4xDLNCvs6XIP2wOXYewbRXleXzQy08tAzKmxK7IbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675988;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=A5qD9mto1b8t7j570XUdQz0qEPjMxf2yjbv5ooP/DXo=;
	b=whJdaexcTZe/hqdMvyHKjpMmcgQr1IVTA+q3VTkhRLT3261QCidRY0bZGRItfhlmWQCw
	 nDJP4Wih72h+KL+2iddPmZc7reYlUY1VPvr5bPn4KJ9m63RHKfgUx46v4SiG//HV3ywFb
	 w2CV1E8/oj6hOnDEjTn6lu7l3jnmuEbxilOfi+MS2XZ0MR4hSxTIUqEdWHv9TXlOnlX9T
	 cO4W1bO3iiwUB+ncQTi+AtHwParKiCSbmjiGDzHMkPwxuYLsb1JkNj4ajAc5blLs8qBx1
	 D6jSEp0oESPKpMMip9tn+naqxS7+WFhGqK5PF7b21DkROO7UqZTEv1VkQ3X7MqHxgoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="RcyvQBh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07330606A330
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 03:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RcyvQBh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940AC1F000C1;
	Tue,  3 Nov 2026 03:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675987;
	bh=A5qD9mto1b8t7j570XUdQz0qEPjMxf2yjbv5ooP/DXo=;
	h=Date:To:From:Subject;
	b=RcyvQBh/ct3OF9PtRoWZ+N2DCKadYwN3v9V4AsAggqBxqU9y3HVR3zdGDPOMMrB2H
	 Y6CfI2JtZjMQvuIrAfN+4suUSjpyZWF3Mfabd9euN51IfuLsVo1bovvgruHx5dXdyL
	 1touAGeIEBX/hnc881+dq/tw+8rWZig1PmEvhwqw=
Date: Mon, 02 Nov 2026 19:19:47 -0800
To: mm-commits@vger.kernel.org,clement.leger@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch removed from -mm tree
Message-Id: <20261103031947.940AC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: mailmap: use Clément Léger's linux.dev mail address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Clément Léger <clement.leger@linux.dev>
Subject: MAINTAINERS: mailmap: use Clément Léger's linux.dev mail address
Date: Thu, 29 Oct 2026 10:51:06 +0100

I recently requested a @linux.dev address so I can keep a consistent one
throughout my contributions and use it for the upcoming ones.  Map my
previously used email addresses to this new one.

Link: https://lore.kernel.org/20261029095107.24985-1-clement.leger@linux.dev
Signed-off-by: Clément Léger <clement.leger@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~maintainers-mailmap-use-clément-légers-linuxdev-mail-address
+++ a/.mailmap
@@ -233,6 +233,10 @@ Chuck Lever <cel@kernel.org> <chuck.leve
 Chuck Lever <cel@kernel.org> <cel@netapp.com>
 Chuck Lever <cel@kernel.org> <cel@citi.umich.edu>
 Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
+Clément Léger <clement.leger@linux.dev> <cleger@kalray.eu>
+Clément Léger <clement.leger@linux.dev> <clement.leger@bootlin.com>
+Clément Léger <clement.leger@linux.dev> <cleger@rivosinc.com>
+Clément Léger <clement.leger@linux.dev> <cleger@meta.com>
 Coiby Xu <coiby.xu@gmail.com> <coxu@redhat.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
--- a/MAINTAINERS~maintainers-mailmap-use-clément-légers-linuxdev-mail-address
+++ a/MAINTAINERS
@@ -20934,7 +20934,7 @@ S:	Maintained
 F:	drivers/char/hw_random/optee-rng.c
 
 OP-TEE RTC DRIVER
-M:	Clément Léger <clement.leger@bootlin.com>
+M:	Clément Léger <clement.leger@linux.dev>
 L:	linux-rtc@vger.kernel.org
 S:	Maintained
 F:	drivers/rtc/rtc-optee.c
@@ -23833,7 +23833,7 @@ F:	Documentation/devicetree/bindings/rtc
 F:	drivers/rtc/rtc-renesas-rtca3.c
 
 RENESAS RZ/N1 A5PSW SWITCH DRIVER
-M:	Clément Léger <clement.leger@bootlin.com>
+M:	Clément Léger <clement.leger@linux.dev>
 L:	linux-renesas-soc@vger.kernel.org
 L:	netdev@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from clement.leger@linux.dev are


