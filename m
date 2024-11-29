Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506D155A59
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 12:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882241; cv=none; b=D+xUVGKj2vsVAWboPlH7pXNgNFm75mdD/ldKQUit/6frm+AgNabG+P4c/GyV6/xzRHryeUxmntnTxM4G7F6N3G2ghRaofV7oks/yO6Uv5s3bsZeglUuhH2tfjYPmqkC5hizIFgj5/zF+N3D0ZW6xpXjrUIn1l4m+5DLMJRgfKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882241; c=relaxed/simple;
	bh=mhYgAmJ9+IjEB2kEpsqgB6CSXGDyJ4TmLf7yq0KtLmY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=EqRu+ucA36gZbTu3/KCKWM2NLir7LhyIOqGTjt1HP0kTcmppROHAYnEjyGb8HPOCFDNFl010JMWQkNqklajdHY0qi1CVNTjNvfH7ouMv5w4q7GWaZ46gnAMaU2Jqk8nCSRncsrqK8Hodk3n6WEdhcsqoaeF0hIIemCKo8qENzrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-70-oSMK6AWROGSGIG5D3EAYuQ-1; Fri, 29 Nov 2024 12:10:36 +0000
X-MC-Unique: oSMK6AWROGSGIG5D3EAYuQ-1
X-Mimecast-MFC-AGG-ID: oSMK6AWROGSGIG5D3EAYuQ
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 29 Nov
 2024 12:10:19 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 29 Nov 2024 12:10:19 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Lorenzo Stoakes' <lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, 'Jakob Hauser'
	<jahau@rocketmail.com>, "mm-commits@vger.kernel.org"
	<mm-commits@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"pedro.falcato@gmail.com" <pedro.falcato@gmail.com>, "mjguzik@gmail.com"
	<mjguzik@gmail.com>, "Jason@zx2c4.com" <Jason@zx2c4.com>, "hch@infradead.org"
	<hch@infradead.org>, "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "arnd@kernel.org" <arnd@kernel.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Subject: RE: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Thread-Topic: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Thread-Index: AQHbQlQ4MiN3uAGeVUaY7KG1eMLcI7LOJXhggAAEEACAAAB24A==
Date: Fri, 29 Nov 2024 12:10:19 +0000
Message-ID: <09dfd66250e24faf969ecd6fe2dd764f@AcuMS.aculab.com>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
 <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
 <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
 <15a2907b-530e-4d0d-9b6e-3fc5a290ecc6@lucifer.local>
In-Reply-To: <15a2907b-530e-4d0d-9b6e-3fc5a290ecc6@lucifer.local>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EHipPE_esQ5cWAf2Uu5qzyA_srh-QWKpE5_sQnPE6oU_1732882236
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Lorenzo Stoakes
> Sent: 29 November 2024 12:06
>=20
> On Fri, Nov 29, 2024 at 11:56:01AM +0000, David Laight wrote:
> > From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Sent: 29 November 2024 11:46
> > >
> > > On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
> > > >
> > > > The patch titled
> > > >      Subject: minmax.h: simplify the variants of clamp()
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename i=
s
> > > >      minmaxh-simplify-the-variants-of-clamp.patch
> > >
> > > Hmm, this was generating kernel test bot reports, should we be taking=
 it without
> > > that being fixed?
> >
> > That is reported for W=3D1 builds and is correctly reporting some very
> > badly broken code - that has always been broken.
> >
> > Probably also only affects allmodconfig builds because the code in
> > question is unlikely to be included.
>=20
> Ah fair play, you are poking around in some creaky, cobweb filled bits of
> the kernel so perhaps not a surprise...
>=20
> We should probably try and sort out the W=3D1 stuff though! And by 'we' I
> mean you obviously ;)

Not me, Jakob is trying to fix the magnetometer/yamaha-yas530.c driver.
But I keep on pointing out just how broken the code was.
So there should be a patch to it (that needs backporting) soon.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

