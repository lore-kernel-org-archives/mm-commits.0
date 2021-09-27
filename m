Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F309C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 08:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 580EA60462
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 08:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhI0IXT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 04:23:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:35039 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233385AbhI0IXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 04:23:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-246-a2v7fuY6M72NeJRdaGcpKg-1; Mon, 27 Sep 2021 09:21:26 +0100
X-MC-Unique: a2v7fuY6M72NeJRdaGcpKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 27 Sep 2021 09:21:24 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Mon, 27 Sep 2021 09:21:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: RE: function prototype element ordering
Thread-Topic: function prototype element ordering
Thread-Index: AQHXr/cM9YlQsZ7AakW1CvFYeW1pq6u1IqgQgAGgrwCAAMkJwA==
Date:   Mon, 27 Sep 2021 08:21:24 +0000
Message-ID: <6a84e8b3fa07483092ae79aeded81797@AcuMS.aculab.com>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook>
 <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook> <YUraGKetS+Tgc7y9@localhost.localdomain>
 <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
 <6a85bbbf952949118cc5f93b57d48265@AcuMS.aculab.com>
 <CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com>
In-Reply-To: <CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com>
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

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjYgU2VwdGVtYmVyIDIwMjEgMjI6MDQNCj4g
DQo+IE9uIFNhdCwgU2VwIDI1LCAyMDIxIGF0IDEyOjQwIFBNIERhdmlkIExhaWdodCA8RGF2aWQu
TGFpZ2h0QGFjdWxhYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSWYgdGhlIGZ1bmN0aW9uIG5hbWUg
c3RhcnRzIGF0IHRoZSBiZWdpbm5pbmcgb2YgYSBsaW5lIGl0IGlzDQo+ID4gbXVjaCBlYXNpZXIg
dG8gZ3JlcCBmb3IgdGhlIGRlZmluaXRpb24uDQo+IA0KPiBUaGF0IGhhcyBhbHdheXMgYmVlbiBh
IGNvbXBsZXRlbHkgYm9ndXMgYXJndW1lbnQuIEkgZ3JlcCB0byBsb29rIHVwDQo+IHRoZSB0eXBl
IGFzIG9mdGVuIGFzIEkgZ3JlcCBmb3IgdGhlIGZ1bmN0aW9uIGRlZmluaXRpb24sIHBsdXMgaXQn
cyBub3QNCj4gYXQgYWxsIHVubGlrZWx5IHRoYXQgdGhlICJmdW5jdGlvbiIgaXMgYWN0dWFsbHkg
YSBtYWNybyB3cmFwcGVyLCBzbw0KPiBncmVwcGluZyBmb3IgdGhlIGJlZ2lubmluZyBvZiBsaW5l
IGlzIGp1c3QgY29tcGxldGVseSB3cm9uZy4NCj4gDQo+IEl0J3MgY29tcGxldGVseSB3cm9uZyBm
b3IgYW5vdGhlciByZWFzb24gdG9vOiBpdCBhc3N1bWVzIGEgc3R5bGUgb2YNCj4gcHJvZ3JhbW1p
bmcgdGhhdCBoYXMgbmV2ZXIgYWN0dWFsbHkgYmVlbiBhbGwgdGhhdCBjb21tb24uIEl0J3MgYSB2
ZXJ5DQo+IHNwZWNpZmljIHBhdHRlcm4gdG8gdmVyeSBzcGVjaWZpYyBwcm9qZWN0cywgYW5kIGFu
eWJvZHkgd2hvIGxlYXJudA0KPiB0aGF0IHBhdHRlcm4gZm9yIHRoZWlyIHByb2plY3QgaXMgZ29p
bmcgdG8gYmUgY29tcGxldGVseSBsb3N0IGFueXdoZXJlDQo+IGVsc2UuIFNvIGRvbid0IGRvIGl0
LiBJdCdzIGp1c3QgYSBiYWQgaWRlYS4NCj4gDQo+IFNvIGEgYnJva2VuICJlYXNpZXIgdG8gZ3Jl
cCBmb3IiIGlzIG5vdCBhbiBleGN1c2UgZm9yICJtYWtlIHRoZSBjb2RlDQo+IGhhcmRlciB0byBy
ZWFkIiBwYXJ0aWN1bGFybHkgd2hlbiBpdCBqdXN0IG1ha2VzIGFub3RoZXIgdHlwZSBvZg0KPiBn
cmVwcGluZyBoYXJkZXIsIGFuZCBpdCdzIG5vdCBhY3R1YWxseSBuZWFybHkgdW5pdmVyc2FsIGVu
b3VnaCB0bw0KPiBhY3R1YWxseSBiZSBhIHVzZWZ1bCBwYXR0ZXJuIGluIHRoZSBmaXJzdCBwbGFj
ZS4NCj4gDQo+IEl0J3Mgbm90IG9ubHkgbmV2ZXIgYmVlbiB0aGUgcGF0dGVybiBpbiB0aGUga2Vy
bmVsLCBidXQgaXQncyBnZW5lcmFsbHkNCj4gbm90IGJlZW4gdGhlIHBhdHRlcm4gYW55d2hlcmUg
ZWxzZSBlaXRoZXIuIEl0J3MgbGl0ZXJhbGx5IG9uZSBvZiB0aGUNCj4gYnJva2VuIEdOVSBjb2Rp
bmcgc3RhbmRhcmRzIC0gYW5kIHRoZSBmYWN0IHRoYXQgYWxtb3N0IGV2ZXJ5IG90aGVyDQo+IHBh
cnQgb2YgdGhlIEdOVSBjb2Rpbmcgc3RhbmRhcmRzIHdlcmUgd3JvbmcgKGluZGVudGF0aW9uLCBw
bGFjZW1lbnQgb2YNCj4gYnJhY2VzLCB5b3UgbmFtZSBpdCkgc2hvdWxkIGdpdmUgeW91IGEgaGlu
dCBhYm91dCBob3cgZ29vZCBfdGhhdF8gb25lDQo+IHdhcy4NCj4gDQo+IEhlcmUncyBhbiBleGVy
Y2lzZSBmb3IgeW91OiBnbyBzZWFyY2ggZm9yIEMgY29kaW5nIGV4YW1wbGVzIG9uIHRoZQ0KPiB3
ZWIsIGFuZCBzZWUgaG93IG1hbnkgb2YgdGhlbSBkbw0KPiANCj4gICAgIGludCBtYWluKGludCBh
cmdjLCBjaGFyICoqYXJndikNCj4gDQo+IHZzIGhvdyBtYW55IG9mIHRoZW0gZG8NCj4gDQo+ICAg
ICBpbnQNCj4gICAgIG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KDQpJdCBtYWtlcyBhIGJp
Z2dlciBkaWZmZXJlbmNlIHdpdGg6DQoNCnN0cnVjdCBmcm9idWxhdGUgKmZpbmRfZnJvYnVsYXRl
KGFyZ3MpDQp3aGljaCBpcyBnb2luZyB0byBuZWVkIGEgbGluZSBicmVhayBzb21ld2hlcmUuDQpF
c3BlY2lhbGx5IHdpdGggdGhlIChzdHJhbmdlKSBydWxlIGFib3V0IGFsaWduaW5nIHRoZSBjb250
aW51ZWQNCmFyZ3VtZW50cyB3aXRoIHRoZSAoLg0KDQpCdXQgSSBkaWRuJ3QgZXhwZWN0IHN1Y2gg
YSBsb25nIHJlc3BvbnNlIDotKQ0KDQpJJ20gc3VyZSB0aGUgbmV0QlNEIHRyZWUgKG1vc3RseSkg
cHV0cyB0aGUgZnVuY3Rpb24gbmFtZSBpbiBjb2x1bW4gMS4NCkJ1dCBhZnRlciB0aGF0IHVzZXMg
dGhlIEsmUiBsb2NhdGlvbiBmb3Ige30gKGFzIGRvZXMgTGludXgpLg0KDQpJdCB0cnVlIHRoYXQg
YSBsb3Qgb2YgJ2NvZGluZyBzdGFuZGFyZHMnIGFyZSBob3JyaWQuDQpQdXR0aW5nICd9IGVsc2Ug
eycgb24gb25lIGxpbmUgaXMgaW1wb3J0YW50IHdoZW4gcmVhZGluZyBjb2RlLg0KRXNwZWNpYWxs
eSBpZiB0aGUgJ30nIHdvdWxkIGJlIGF0IHRoZSBib3R0b20gb2YgdGhlIHNjcmVlbiwNCm9yIHdv
cnNlIHN0aWxsIHR1cm5pbmcgdGhlIHBhZ2Ugb24gYSBmYW4tZm9sZCBwYXBlciBsaXN0aW5nIHRv
IGZpbmQNCmEgZmxvYXRpbmcgJ2Vsc2UnID0gd2l0aCBubyBpZGVhIHdoaWNoICdpZicgaXQgZ29l
cyB3aXRoLg0KDQpUaGUgbW9kZXJuIGV4YW1wbGUgb2Ygd2h5IHsgYW5kIH0gc2hvdWxkbid0IGJl
IG9uIHRoZWlyIG93biBsaW5lcyBpczoNCgkJLi4uDQoJfQ0KCXdoaWxlICguLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4NCgl7DQoJCS4uLg0KSXMgdGhhdCBhIGxvb3AgYm90dG9tIGZvbGxvd2Vk
IGJ5IGEgY29kZSBibG9jayBvcg0KYSBjb25kaXRpb25hbCBmb2xsb3dlZCBieSBhIGxvb3A/DQoN
CkJ1dCBub25lIG9mIHRoaXMgaXMgcmVsYXRlZCB0byB0aGUgbG9jYXRpb24gb2YgYXR0cmlidXRl
cyB1bmxlc3MNCnlvdSBuZWVkIHRvIHNwbGl0IGxvbmcgbGluZXMgYW5kIHB1dCB0aGUgYXR0cmli
dXRlIGJlZm9yZSB0aGUNCmZ1bmN0aW9uIG5hbWUgd2hlcmUgeW91IG1heSBuZWVkLg0KDQpzdGF0
aWMgc3RydWN0IGZyb2J1bGF0ZSAqDQpfX2lubGluZSAuLi4uDQpmaW5kX2Zyb2J1bGF0ZSguLi4u
KQ0KDQpFc3BlY2lhbGx5IGlmIHlvdSBuZWVkICNpZiBhcm91bmQgdGhlIGF0dHJpYnV0ZXMuDQoN
CglEYXZpZA0KDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

