Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEA0C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 06:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD1361DC2
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 06:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhF2GcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 02:32:09 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:52998 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231881AbhF2GcJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jun 2021 02:32:09 -0400
X-UUID: 91dbe2c430a244bcb4e6813bca0821e3-20210629
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AlvawD64FTfj7oAZ2nGaxLppC8wUadk5dY1FAIro6qE=;
        b=OyN0kn85vxO+ThLPkxjPJ4VeSB1vdQLe9njR4Nf1garfcDVPnBgCRdnmMX8uWq5VtkIXWTu1EYStEuTRm8beavY0wde6fkcm1dFQ7ImS5tdS/Ym5Mvl8rtJdg5LkuELN4WuX8PMsndr++8Y+nGEbQeJvKRq58HNOx0zwKtg27es=;
X-UUID: 91dbe2c430a244bcb4e6813bca0821e3-20210629
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <yee.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1059558924; Tue, 29 Jun 2021 14:29:39 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 29 Jun 2021 14:29:38 +0800
Received: from mtksdccf07 (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Jun 2021 14:29:37 +0800
Message-ID: <1881e4ca9fda966cc4192f45623f85353bc93463.camel@mediatek.com>
Subject: Re: +
 kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch added to
 -mm tree
From:   Yee Lee <yee.lee@mediatek.com>
To:     <akpm@linux-foundation.org>
CC:     <andreyknvl@gmail.com>, <dvyukov@google.com>, <glider@google.com>,
        <matthias.bgg@gmail.com>, <mm-commits@vger.kernel.org>,
        <ryabinin.a.a@gmail.com>, <elver@google.com>
Date:   Tue, 29 Jun 2021 14:29:38 +0800
In-Reply-To: <20210624205419.S-O4JsHNk%akpm@linux-foundation.org>
References: <20210624205419.S-O4JsHNk%akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

SGkgQW5kcmV3LCANCg0KVGhhbmtzIGZvciB5b3VyIGhlbHAgdG8gYWRkIHRoaXMgcGF0Y2guDQpV
bmZvcnVuYXRlbHksIHdlIG5lZWQgYSBsaXR0bGUgY2hhbmdlIG9uIGNvZGVzIGJhc2VkIG9uIEFu
ZHJleSBhbmQNCk1hcmNvJ3Mgc3VnZ2VzdGlvbi4NCg0KUGxlYXNlIGRyb3AgdGhpcyBvbmUsIGFu
ZCBJIHdpbGwgc2VuZCBhIG5ldyB2ZXJzaW9uIHNvb24uDQpBcHByZWFjaWF0ZWQgdGhlIHdvcmsh
DQoNCkJlc3QgcmVnYXJkcywNCg0KWWVlDQoNCk9uIFRodSwgMjAyMS0wNi0yNCBhdCAxMzo1NCAt
MDcwMCwgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIHRpdGxl
ZA0KPiAgICAgIFN1YmplY3Q6IGthc2FuOiBhZGQgbWVtemVybyBpbml0IGZvciB1bmFsaWduZWQg
c2l6ZSB1bmRlciBTTFVCDQo+IGRlYnVnDQo+IGhhcyBiZWVuIGFkZGVkIHRvIHRoZSAtbW0gdHJl
ZS4gIEl0cyBmaWxlbmFtZSBpcw0KPiAgICAgIGthc2FuLWFkZC1tZW16ZXJvLWluaXQtZm9yLXVu
YWxpZ25lZC1zaXplLXVuZGVyLXNsdWItZGVidWcucGF0Y2gNCj4gDQo+IFRoaXMgcGF0Y2ggc2hv
dWxkIHNvb24gYXBwZWFyIGF0DQo+ICAgICANCj4gaHR0cHM6Ly9vemxhYnMub3JnL35ha3BtL21t
b3RzL2Jyb2tlbi1vdXQva2FzYW4tYWRkLW1lbXplcm8taW5pdC1mb3ItdW5hbGlnbmVkLXNpemUt
dW5kZXItc2x1Yi1kZWJ1Zy5wYXRjaA0KPiBhbmQgbGF0ZXIgYXQNCj4gICAgIA0KPiBodHRwczov
L296bGFicy5vcmcvfmFrcG0vbW1vdG0vYnJva2VuLW91dC9rYXNhbi1hZGQtbWVtemVyby1pbml0
LWZvci11bmFsaWduZWQtc2l6ZS11bmRlci1zbHViLWRlYnVnLnBhdGNoDQo+IA0KPiBCZWZvcmUg
eW91IGp1c3QgZ28gYW5kIGhpdCAicmVwbHkiLCBwbGVhc2U6DQo+ICAgIGEpIENvbnNpZGVyIHdo
byBlbHNlIHNob3VsZCBiZSBjYydlZA0KPiAgICBiKSBQcmVmZXIgdG8gY2MgYSBzdWl0YWJsZSBt
YWlsaW5nIGxpc3QgYXMgd2VsbA0KPiAgICBjKSBJZGVhbGx5OiBmaW5kIHRoZSBvcmlnaW5hbCBw
YXRjaCBvbiB0aGUgbWFpbGluZyBsaXN0IGFuZCBkbyBhDQo+ICAgICAgIHJlcGx5LXRvLWFsbCB0
byB0aGF0LCBhZGRpbmcgc3VpdGFibGUgYWRkaXRpb25hbCBjYydzDQo+IA0KPiAqKiogUmVtZW1i
ZXIgdG8gdXNlIERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJtaXQtY2hlY2tsaXN0LnJzdCB3aGVu
DQo+IHRlc3RpbmcgeW91ciBjb2RlICoqKg0KPiANCj4gVGhlIC1tbSB0cmVlIGlzIGluY2x1ZGVk
IGludG8gbGludXgtbmV4dCBhbmQgaXMgdXBkYXRlZA0KPiB0aGVyZSBldmVyeSAzLTQgd29ya2lu
ZyBkYXlzDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gRnJvbTogWWVlIExlZSA8eWVlLmxlZUBtZWRpYXRlay5jb20+DQo+IFN1
YmplY3Q6IGthc2FuOiBhZGQgbWVtemVybyBpbml0IGZvciB1bmFsaWduZWQgc2l6ZSB1bmRlciBT
TFVCIGRlYnVnDQo+IA0KPiBJc3N1ZTogd2hlbiBTTFVCIGRlYnVnIGlzIG9uLCBod3RhZyBrYXNh
bl91bnBvaXNvbigpIHdvdWxkIG92ZXJ3cml0ZQ0KPiB0aGUNCj4gcmVkem9uZSBvZiBvYmplY3Qg
d2l0aCB1bmFsaWduZWQgc2l6ZS4NCj4gDQo+IEFuIGFkZGl0aW9uYWwgbWVtemVyb19leHBsaWNp
dCgpIHBhdGggaXMgYWRkZWQgdG8gcmVwbGFjaW5nIGluaXQgYnkNCj4gaHd0YWcNCj4gaW5zdHJ1
Y3Rpb24gZm9yIHRob3NlIHVuYWxpZ25lZCBzaXplIGF0IFNMVUIgZGVidWcgbW9kZS4NCj4gDQo+
IExpbms6IA0KPiBodHRwczovL2xrbWwua2VybmVsLm9yZy9yLzIwMjEwNjI0MTEyNjI0LjMxMjE1
LTIteWVlLmxlZUBtZWRpYXRlay5jb20NCj4gU2lnbmVkLW9mZi1ieTogWWVlIExlZSA8eWVlLmxl
ZUBtZWRpYXRlay5jb20+DQo+IENjOiBBbmRyZXkgS29ub3ZhbG92IDxhbmRyZXlrbnZsQGdtYWls
LmNvbT4NCj4gQ2M6IEFuZHJleSBSeWFiaW5pbiA8cnlhYmluaW4uYS5hQGdtYWlsLmNvbT4NCj4g
Q2M6IEFsZXhhbmRlciBQb3RhcGVua28gPGdsaWRlckBnb29nbGUuY29tPg0KPiBDYzogRG1pdHJ5
IFZ5dWtvdiA8ZHZ5dWtvdkBnb29nbGUuY29tPg0KPiBDYzogTWF0dGhpYXMgQnJ1Z2dlciA8bWF0
dGhpYXMuYmdnQGdtYWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IE1vcnRvbiA8YWtw
bUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gLS0tDQo+IA0KPiAgbW0va2FzYW4va2FzYW4uaCB8
ICAgIDYgKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+IA0KPiAt
LS0gYS9tbS9rYXNhbi9rYXNhbi5ofmthc2FuLWFkZC1tZW16ZXJvLWluaXQtZm9yLXVuYWxpZ25l
ZC1zaXplLQ0KPiB1bmRlci1zbHViLWRlYnVnDQo+ICsrKyBhL21tL2thc2FuL2thc2FuLmgNCj4g
QEAgLTM4Nyw2ICszODcsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIGthc2FuX3VucG9pc29uKGNv
bnN0DQo+ICANCj4gIAlpZiAoV0FSTl9PTigodW5zaWduZWQgbG9uZylhZGRyICYgS0FTQU5fR1JB
TlVMRV9NQVNLKSkNCj4gIAkJcmV0dXJuOw0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX1NMVUJf
REVCVUcpDQo+ICsJaWYgKGluaXQgJiYgKCh1bnNpZ25lZCBsb25nKXNpemUgJiBLQVNBTl9HUkFO
VUxFX01BU0spKSB7DQo+ICsJCWluaXQgPSBmYWxzZTsNCj4gKwkJbWVtemVyb19leHBsaWNpdCgo
dm9pZCAqKWFkZHIsIHNpemUpOw0KPiArCX0NCj4gKyNlbmRpZg0KPiAgCXNpemUgPSByb3VuZF91
cChzaXplLCBLQVNBTl9HUkFOVUxFX1NJWkUpOw0KPiAgDQo+ICAJaHdfc2V0X21lbV90YWdfcmFu
Z2UoKHZvaWQgKilhZGRyLCBzaXplLCB0YWcsIGluaXQpOw0KPiBfDQo+IA0KPiBQYXRjaGVzIGN1
cnJlbnRseSBpbiAtbW0gd2hpY2ggbWlnaHQgYmUgZnJvbSB5ZWUubGVlQG1lZGlhdGVrLmNvbSBh
cmUNCj4gDQo+IGthc2FuLWFkZC1tZW16ZXJvLWluaXQtZm9yLXVuYWxpZ25lZC1zaXplLXVuZGVy
LXNsdWItZGVidWcucGF0Y2gNCj4gDQo=

