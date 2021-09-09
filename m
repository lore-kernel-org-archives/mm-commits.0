Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C041BC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 08:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9970660E76
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 08:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhIII30 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 04:29:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:52781 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231485AbhIII3Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 04:29:25 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-6-sNc0KnRGOlexmKiha1mMKQ-1;
 Thu, 09 Sep 2021 09:28:14 +0100
X-MC-Unique: sNc0KnRGOlexmKiha1mMKQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 9 Sep 2021 09:28:13 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 9 Sep 2021 09:28:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "drew@beagleboard.org" <drew@beagleboard.org>,
        Guo Ren <guoren@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "kernel@esmil.dk" <kernel@esmil.dk>, Linux-MM <linux-mm@kvack.org>,
        "mcroce@microsoft.com" <mcroce@microsoft.com>,
        "mick@ics.forth.gr" <mick@ics.forth.gr>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: RE: [patch 102/147] lib/string: optimized memmove
Thread-Topic: [patch 102/147] lib/string: optimized memmove
Thread-Index: AQHXpN+CtaS3kgSOR0WmvLnySjsGZKubXd4w
Date:   Thu, 9 Sep 2021 08:28:13 +0000
Message-ID: <dda36adec98e47d0b35d58a4e4d4bdcb@AcuMS.aculab.com>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025842.MCdSIuFM5%akpm@linux-foundation.org>
 <CAHk-=wg2M2qLWKEZg7FfeQM6jyLDr=pySCP0vDEW2sRu9gtncA@mail.gmail.com>
In-Reply-To: <CAHk-=wg2M2qLWKEZg7FfeQM6jyLDr=pySCP0vDEW2sRu9gtncA@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDggU2VwdGVtYmVyIDIwMjEgMTk6MzANCj4g
DQo+IE9uIFR1ZSwgU2VwIDcsIDIwMjEgYXQgNzo1OCBQTSBBbmRyZXcgTW9ydG9uIDxha3BtQGxp
bnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPg0KPiA+IFdoZW4gdGhlIGRlc3RpbmF0aW9u
IGJ1ZmZlciBpcyBiZWZvcmUgdGhlIHNvdXJjZSBvbmUsIG9yIHdoZW4gdGhlIGJ1ZmZlcnMNCj4g
PiBkb2Vzbid0IG92ZXJsYXAsIGl0J3Mgc2FmZSB0byB1c2UgbWVtY3B5KCkgaW5zdGVhZCwgd2hp
Y2ggaXMgb3B0aW1pemVkIHRvDQo+ID4gdXNlIGEgYmlnZ2VyIGRhdGEgc2l6ZSBwb3NzaWJsZS4N
Cj4gDQo+IFRoaXMgb25lIGlzIGFjdGl2ZWx5IGJ1Z2d5Lg0KPiANCj4gSXQgZGVwZW5kcyBvbiB0
aGUgcG9zc2libHkgaW5jb3JyZWN0IGFzc3VtcHRpb24gdGhhdCBtZW1jcHkoKSBhbHdheXMNCj4g
Y29waWVzIHVwd2FyZHMuDQoNCkV2ZW4gaWYgdGhlIG1lbWNweSgpICdtb3N0bHknIGNvcGllcyB1
cHdhcmRzIGl0IG1heSBjb3B5IHRoZSBsYXN0DQo4IGJ5dGVzIGZpcnN0IGFuZCB0aGVuIGNvcHkg
dGhlIHJlc3Qgb2YgdGhlIGJ1ZmZlciBpbiA4IGJ5dGUgY2h1bmtzLg0KDQpPVE9IIHRoZSBjaGFu
Z2UgdG8gbGliYyB0aGF0IG1hZGUgaXQgZG8gYmFja3dhcmRzIGlzIGp1c3Qgc3R1cGlkLg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

