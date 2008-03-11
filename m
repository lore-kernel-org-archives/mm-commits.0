From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kvm: provide kvm.h for all architecture: fixes
 headers_install
Date: Mon, 10 Mar 2008 23:20:39 -0700
Message-ID: <20080310232039.d2a34f5a.akpm__2698.31691771305$1205216612$gmane$org@linux-foundation.org>
References: <200803071326.06682.borntraeger@de.ibm.com>
	<1204933418.2495.14.camel@shinybook.infradead.org>
	<200803101411.04175.borntraeger@de.ibm.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYCKGW3 convert rfc822-to-8bit
	(ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 02:22:29 -0400
In-Reply-To: <200803101411.04175.borntraeger@de.ibm.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@qumranet.com>, Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org

On Mon, 10 Mar 2008 14:11:04 +0100 Christian Borntraeger <borntraeger@d=
e.ibm.com> wrote:

> [PATCH v2] kvm: provide kvm.h for all architecture: fixes headers_ins=
tall
>=20
> Currently include/linux/kvm.h is not considered by make headers_insta=
ll,=20
> because Kbuild cannot handle " unifdef-$(CONFIG_FOO) +=3D foo.h.=20
> This problem was introduced by 040922c04cf2c8ac70be2e88a8a9614ecdb41d=
2e,=20
> which makes this an 2.6.25 regression.
>=20
> One way of solving the issue is to enhance Kbuild, but Avi Kivity and=
 David
> Woodhouse conviced me, that changing headers_install is not the way t=
o go.=20
> This patch changes the definition for linux/kvm.h to unifdef-y.
>=20
> If =A0unifdef-y is used for linux/kvm.h "make headers_check" will fai=
l on all
> architectures without asm/kvm.h. Therefore, this patch also provides=20
> asm/kvm.h on all architectures.
>=20
> Changes since v1:
> o use asm-generic/Kbuild.asm (Arnd Bergmann)
> o fix comment in asm-frv (David Howells)

err, this doesn't work.

alpha and m68k (at least) fail make headers_check

/usr/src/devel/usr/include/linux/kvm.h requires asm/kvm.h, which does n=
ot exist in exported headers
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
