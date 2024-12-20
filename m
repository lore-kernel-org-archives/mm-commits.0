Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0255074059;
	Fri, 20 Dec 2024 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734674790; cv=none; b=cI8NxSYhlbgrqdyHtQLnWoixRqlRJyRVtj31Sm3NyS2UvreuvHcJMBDf+oyGz6lgnYj9Qf/rEz5ZhVVO+jU5OpsWmGVm4r6i7reIsKDDd6SWMp01ZLavrkzbwZadVLPuXsQHM71DujloNs7+348l1GtpNrT1Zc2kdLmppjrCtsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734674790; c=relaxed/simple;
	bh=2RbFRUgw/qI9zihNzLR2Q2ojXC2qlL4c3ZQfciTB1hI=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=Plgtbj8cgduI8ACzDDmbIJXPhN4eL0k47H7DafvcPopWchwnN6PfTp0KUV7k/tvYqDM+C/IqQIlz8mg7wTB/7iMaiqGaN01ZBw3uSKi0DrtjvYbqR5CZCB2P2nrt3HRbD4SPc4NA8vwAKQN+iz8kdbOBXVVGwbFFWr6pwPAMM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=ux8YekwF; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="ux8YekwF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1734674787; x=1766210787;
  h=from:in-reply-to:references:date:cc:to:mime-version:
   message-id:subject:content-transfer-encoding;
  bh=2RbFRUgw/qI9zihNzLR2Q2ojXC2qlL4c3ZQfciTB1hI=;
  b=ux8YekwFA4xTQEf9mLullmg850RZ9fCtN132hNsN4KaV8GeAuHCvOery
   yj26IWsAw+GOlHrzPF0WaXQm218GGP5w5bBdymWm6bPSXdlvj6Bxh+1MT
   2pY3nt1tgAO0ijAN7mIueXVa7V6OXruDFBVaoucEo4cIJS2LdkEvpMY36
   0=;
X-CSE-ConnectionGUID: x7KDBgJ+RDmCofNbz/mOcQ==
X-CSE-MsgGUID: cat6bxRdT9+Hz3AwkC8aKA==
X-IronPort-AV: E=Sophos;i="6.12,249,1728943200"; 
   d="scan'208";a="28265590"
Received: from quovadis.eurecom.fr ([10.3.2.233])
  by drago1i.eurecom.fr with ESMTP; 20 Dec 2024 07:06:19 +0100
From: "Ariel Otilibili-Anieli" <Ariel.Otilibili-Anieli@eurecom.fr>
In-Reply-To: <20241219231352.579D5C4CECE@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 88.183.119.157
References: <20241219231352.579D5C4CECE@smtp.kernel.org>
Date: Fri, 20 Dec 2024 07:06:18 +0100
Cc: mm-commits@vger.kernel.org, sstabellini@kernel.org, roger.pau@citrix.com, michal.orzel@amd.com, julien@xen.org, jbeulich@suse.com, anthony.perard@vates.tech, andrew.cooper3@citrix.com, stable@vger.kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2f7a83-67650980-a2c7-5cf12280@54007280>
Subject: =?utf-8?q?Re=3A?= + =?utf-8?q?lib-remove-dead-code=2Epatch?= added to 
 mm-nonmm-unstable branch
User-Agent: SOGoMail 5.11.1
Content-Transfer-Encoding: quoted-printable

On Friday, December 20, 2024 00:13 CET, Andrew Morton <akpm@linux-found=
ation.org> wrote:

>=20
> The patch titled
>      Subject: lib/inflate.c: remove dead code
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      lib-remove-dead-code.patch
>=20
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/=
tree/patches/lib-remove-dead-code.patch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed

Hello Andrew,

Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: xen-devel@lists.xenproject.org

https://lore.kernel.org/lkml/20241219224645.749233-1-ariel.otilibili-an=
ieli@eurecom.fr/

Thank you,
Ariel
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when t=
esting your code ***
>=20
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>=20
> ------------------------------------------------------
> From: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
> Subject: lib/inflate.c: remove dead code
> Date: Thu, 19 Dec 2024 10:21:12 +0100
>=20
> This is a follow up from a discussion in Xen:
>=20
> The if-statement tests that `res` is non-zero; meaning the case zero =
is
> never reached.
>=20
> Link: https://lore.kernel.org/all/7587b503-b2ca-4476-8dc9-e9683d4ca5f=
0@suse.com/
> Link: https://lkml.kernel.org/r/20241219092615.644642-2-ariel.otilibi=
li-anieli@eurecom.fr
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andrew Cooper <andrew.cooper3@citrix.com>
> Cc: Anthony PERARD <anthony.perard@vates.tech>
> Cc: Michal Orzel <michal.orzel@amd.com>
> Cc: Julien Grall <julien@xen.org>
> Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  lib/inflate.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> --- a/lib/inflate.c~lib-remove-dead-code
> +++ a/lib/inflate.c
> @@ -1257,8 +1257,6 @@ static int INIT gunzip(void)
>      /* Decompress */
>      if ((res =3D inflate())) {
>  	    switch (res) {
> -	    case 0:
> -		    break;
>  	    case 1:
>  		    error("invalid compressed format (err=3D1)");
>  		    break;
> =5F
>=20
> Patches currently in -mm which might be from ariel.otilibili-anieli@e=
urecom.fr are
>=20
> lib-remove-dead-code.patch
>

