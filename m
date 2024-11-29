Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BD2199FAF
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732881390; cv=none; b=DmrJj+hjXS3/RNgxK65URE744ev64ddNT0PnL7Ac9TXQOf8Qf7FhhYlV+A4y+HWCjZeG4hPlpDhlpX+4F7izI7WVQu3HoInApxMyI36Gl4982JVhEsGY0VmH8trg6uL0+qzwIzxJ/gx+mR2YhfS0XseW6qboUdMzp4TXUEqJ8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732881390; c=relaxed/simple;
	bh=KYhmnT7DfzVaJ/PCdURHZjir2DMkjrxSZSGrH1KOiq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=CuvehPb8o6Gi6sh+I6kqFtDWrSoPE1Gd0h5loDgrz7gdzq1la/3xbLZQE8YUqD1LjH5fk7pBk7cSw8jS9/E5iB99EgSyohRKxlMVftxG1YL94pHto28arQikewKeTC7EIcMVzAehNUSGwipW7/7LbML8OeSHTKi3p2pAQ9qPSxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-267-g57NBnoIP2iTyM6oczX64g-1; Fri, 29 Nov 2024 11:56:18 +0000
X-MC-Unique: g57NBnoIP2iTyM6oczX64g-1
X-Mimecast-MFC-AGG-ID: g57NBnoIP2iTyM6oczX64g
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 29 Nov
 2024 11:56:01 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 29 Nov 2024 11:56:01 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Lorenzo Stoakes' <lorenzo.stoakes@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, 'Jakob Hauser' <jahau@rocketmail.com>
CC: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "pedro.falcato@gmail.com"
	<pedro.falcato@gmail.com>, "mjguzik@gmail.com" <mjguzik@gmail.com>,
	"Jason@zx2c4.com" <Jason@zx2c4.com>, "hch@infradead.org" <hch@infradead.org>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "arnd@kernel.org" <arnd@kernel.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Subject: RE: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Thread-Topic: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
Thread-Index: AQHbQlQ4MiN3uAGeVUaY7KG1eMLcI7LOJXhg
Date: Fri, 29 Nov 2024 11:56:01 +0000
Message-ID: <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
 <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
In-Reply-To: <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
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
X-Mimecast-MFC-PROC-ID: eQZ7s3rK9yNwP--J6twfolMec7cKqlZXPNXzxu033IQ_1732881377
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Sent: 29 November 2024 11:46
>=20
> On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: minmax.h: simplify the variants of clamp()
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      minmaxh-simplify-the-variants-of-clamp.patch
>=20
> Hmm, this was generating kernel test bot reports, should we be taking it =
without
> that being fixed?

That is reported for W=3D1 builds and is correctly reporting some very
badly broken code - that has always been broken.

Probably also only affects allmodconfig builds because the code in
question is unlikely to be included.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

