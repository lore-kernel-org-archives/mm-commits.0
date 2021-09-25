Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43FFC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 25 Sep 2021 19:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC22610CE
	for <mm-commits@archiver.kernel.org>; Sat, 25 Sep 2021 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhIYTmU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Sep 2021 15:42:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:59780 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229842AbhIYTmU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Sep 2021 15:42:20 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-235--XtKN3_VNjyVzPJ2CaVfBQ-1; Sat, 25 Sep 2021 20:40:42 +0100
X-MC-Unique: -XtKN3_VNjyVzPJ2CaVfBQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Sat, 25 Sep 2021 20:40:41 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Sat, 25 Sep 2021 20:40:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        "Pekka Enberg" <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: RE: function prototype element ordering
Thread-Topic: function prototype element ordering
Thread-Index: AQHXr/cM9YlQsZ7AakW1CvFYeW1pq6u1IqgQ
Date:   Sat, 25 Sep 2021 19:40:41 +0000
Message-ID: <6a85bbbf952949118cc5f93b57d48265@AcuMS.aculab.com>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook>
 <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook> <YUraGKetS+Tgc7y9@localhost.localdomain>
 <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
In-Reply-To: <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
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

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjIgU2VwdGVtYmVyIDIwMjEgMjI6MTYNCi4u
Lg0KPiBXZSBkb24ndCBwdXQgZnVuY3Rpb24gcmV0dXJuIHR5cGVzIG9uIHRoZWlyIG93biBsaW5l
cyBlaXRoZXIsIGV2ZW4gaWYNCj4gc29tZSBvdGhlciBwcm9qZWN0cyBoYXZlIHRoYXQgcnVsZSAo
anVzdCB0byBnZXQgZnVuY3Rpb24gbmFtZXMgYXQgdGhlDQo+IGJlZ2lubmluZyBvZiBsaW5lcyBv
ciBzb21lIG90aGVyIG9kZCByZWFzb24pLg0KDQpJZiB0aGUgZnVuY3Rpb24gbmFtZSBzdGFydHMg
YXQgdGhlIGJlZ2lubmluZyBvZiBhIGxpbmUgaXQgaXMNCm11Y2ggZWFzaWVyIHRvIGdyZXAgZm9y
IHRoZSBkZWZpbml0aW9uLg0KVHJ5aW5nIHRvIGZpbmQgZnVuY3Rpb24gZGVmaW5pdGlvbnMgaW4g
dGhlIExpbnV4IGtlcm5lbCB0cmVlDQppcyBhIFBJVEEgLSB1bmxlc3MgdGhleSBhcmUgZXhwb3J0
ZWQgd2hlbiAnRVhQT1JULiooZnVuY3Rpb25fbmFtZSknDQp3aWxsIHRlbmQgdG8gd29yay4NCg0K
VHJ5aW5nIHRvIGNvbXBpbGU6DQpzdGF0aWMgaW50IHgoaW50IHkpIF9fYXR0cmlidXRlX18oKHNl
Y3Rpb24oIngiKSkpIHsgcmV0dXJuIHk7fQ0Kd2l0aCBnY2MgZ2VuZXJhdGVzICJlcnJvcjogYXR0
cmlidXRlcyBhcmUgbm90IGFsbG93ZWQgb24gYSBmdW5jdGlvbi1kZWZpbml0aW9uIi4NCg0KUHV0
dGluZyB0aGUgYXR0cmlidXRlIGFueXdoZXJlIGJlZm9yZSB0aGUgZnVuY3Rpb24gbmFtZSB3b3Jr
cyBmaW5lLg0KZ2NjIHByb2JhYmx5IGFjY2VwdHM6DQpfX2lubGluZSBzdGF0aWMgX19pbmxpbmUg
aW50IF9faW5saW5lIHgodm9pZCkge3JldHVybiAwO30gDQoNClNvIGFueSBvZiB0aG9zZSBsb2Nh
dGlvbnMgaXMgcGxhdXNpYmxlLg0KQnV0IGFmdGVyIHRoZSBhcmd1bWVudHMgaXNuJ3QgYWxsb3dl
ZC4NClNvIGFuIChleHRlcm4pIGZ1bmN0aW9uIGRlY2xhcmF0aW9uIHByb2JhYmx5IHNob3VsZCBu
b3QgcHV0IHRoZW0NCnRoZXJlIC0gaWYgb25seSBmb3IgY29uc2lzdGVuY3kuDQoNCkkgdGhpbmsg
SSdkIGdvIGZvciAnZmlyc3QnIC0gb3B0aW9uYWxseSBvbiB0aGVpciBvd24gbGluZS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

