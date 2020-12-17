Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9A2C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 13:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A0D42360D
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 13:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgLQNuy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 08:50:54 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:48120 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727415AbgLQNuy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2020 08:50:54 -0500
X-UUID: 4c1d855ebfc64539adaf73f788373e22-20201217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Td1AyI4zcaq8k5MvKxnqgKo1dz35BSP0xmNpAqoDwzU=;
        b=B+K+ROtPkuXwi3xFE1EMA2uoXAGYd6AUcb2S79SOu/ovW5YfOh0axa+T1m0xXQzIVJ8L4DMSmG7e86To0m5D1wM6UlI/o9lOpvV40R7T7BryYDHhPe8zRYRb56z7VxnIH41TJiZ4ZYp7sxl0FLe1GNr+hD4r4ahovTPPmbgjy+g=;
X-UUID: 4c1d855ebfc64539adaf73f788373e22-20201217
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <kuan-ying.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 366053075; Thu, 17 Dec 2020 21:50:09 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 21:50:07 +0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 21:50:06 +0800
Message-ID: <1608213009.31376.85.camel@mtksdccf07>
Subject: Re: [merged]
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch removed from
 -mm tree
From:   Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <aryabinin@virtuozzo.com>, <dvyukov@google.com>,
        <glider@google.com>, <guangye.yang@mediatek.com>,
        <matthias.bgg@gmail.com>, <miles.chen@mediatek.com>,
        <mm-commits@vger.kernel.org>, <nicholas.tang@mediatek.com>,
        <qcai@redhat.com>, <qiang.zhang@windriver.com>,
        <sfr@canb.auug.org.au>, <walter-zh.wu@mediatek.com>
Date:   Thu, 17 Dec 2020 21:50:09 +0800
In-Reply-To: <1608023217.31376.35.camel@mtksdccf07>
References: <20201213060524.pmMPPz32b%akpm@linux-foundation.org>
         <1607924810.31376.14.camel@mtksdccf07>
         <20201214101957.51e0e05d2b7bf5d2f9707bd2@linux-foundation.org>
         <1608023217.31376.35.camel@mtksdccf07>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTE1IGF0IDE3OjA2ICswODAwLCBLdWFuLVlpbmcgTGVlIHdyb3RlOg0K
PiBPbiBNb24sIDIwMjAtMTItMTQgYXQgMTA6MTkgLTA4MDAsIEFuZHJldyBNb3J0b24gd3JvdGU6
DQo+ID4gT24gTW9uLCAxNCBEZWMgMjAyMCAxMzo0Njo1MCArMDgwMCBLdWFuLVlpbmcgTGVlIDxL
dWFuLVlpbmcuTGVlQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gPiBPbiBTYXQsIDIw
MjAtMTItMTIgYXQgMjI6MDUgLTA4MDAsIGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcgd3JvdGU6
DQo+ID4gPiA+IFRoZSBwYXRjaCB0aXRsZWQNCj4gPiA+ID4gICAgICBTdWJqZWN0OiBrYXNhbjog
Zml4IG9iamVjdCByZW1haW5pbmcgaW4gb2ZmbGluZSBwZXItY3B1IHF1YXJhbnRpbmUNCj4gPiA+
ID4gaGFzIGJlZW4gcmVtb3ZlZCBmcm9tIHRoZSAtbW0gdHJlZS4gIEl0cyBmaWxlbmFtZSB3YXMN
Cj4gPiA+ID4gICAgICBrYXNhbi1maXgtb2JqZWN0LXJlbWFpbi1pbi1vZmZsaW5lLXBlci1jcHUt
cXVhcmFudGluZS5wYXRjaA0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBwYXRjaCB3YXMgZHJvcHBl
ZCBiZWNhdXNlIGl0IHdhcyBtZXJnZWQgaW50byBtYWlubGluZSBvciBhIHN1YnN5c3RlbSB0cmVl
DQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBIaSBBbmRyZXcsDQo+ID4gPiANCj4gPiA+IFNvcnJ5
IHRvIGJvdGhlci4NCj4gPiA+IFRoaXMgcGF0Y2ggaGFzIGRlcGVuZGVuY3kgd2l0aCB0d28gcGF0
Y2hlcyBvZiBBbmRyZXkncyBwYXRjaCBzZXJpZXMgYXMNCj4gPiA+IGJlbG93Lg0KPiA+ID4gImth
c2FuOiByZW5hbWUgZ2V0X2FsbG9jL2ZyZWVfaW5mbyINCj4gPiA+ICJrYXNhbjogc2FuaXRpemUg
b2JqZWN0cyB3aGVuIG1ldGFkYXRhIGRvZXNudCBmaXQiDQo+ID4gDQo+ID4gQXJlIHlvdSBzdXJl
PyAgUGxlYXNlIGNoZWNrIDUuMTAgYW5kIGlmIHRoZXJlIGFyZSBwcm9ibGVtcyB0aGVyZSwNCj4g
PiBwbGVhc2UgcHJvcG9zZSBhIHN0YW5kYWxvbmUgZml4Lg0KPiA+IA0KPiANCj4gWWVzLg0KPiAN
Cj4gQW5kcmV5J3MgcGF0Y2ggaGFzIHRoZSByZXR1cm4gdmFsdWUgYW5kIHJldHVybiBmYWxzZS4N
Cj4gUmV0dXJuIGZhbHNlIHdpbGwgbWFrZSBzbGFiIGFsbG9jYXRvciBmcmVlIHRoZSBvYmplY3Qg
YW5kIHFsaW5rX2ZyZWUoKQ0KPiBhbHNvIGZyZWUgdGhlIG9iamVjdCwgc28gUWlhbmcgcmVtb3Zl
IHRoZSBxbGlua19mcmVlKCkgdG8gcmVzb2x2ZSB0aGUNCj4gZG91YmxlIGZyZWUgYXMgYmVsb3cu
DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjAxMjA0MTAyMjA2LjIwMjM3
LTEtcWlhbmcuemhhbmdAd2luZHJpdmVyLmNvbS8NCj4gDQo+ICAJcSA9IHRoaXNfY3B1X3B0cigm
Y3B1X3F1YXJhbnRpbmUpOw0KPiAgCWlmIChxLT5vZmZsaW5lKSB7DQo+IC0JCXFsaW5rX2ZyZWUo
Jm1ldGEtPnF1YXJhbnRpbmVfbGluaywgY2FjaGUpOyAvLyBmcmVlIG9uY2UNCj4gIAkJbG9jYWxf
aXJxX3Jlc3RvcmUoZmxhZ3MpOw0KPiAgCQlyZXR1cm4gZmFsc2U7ICAvLyBmcmVlIHR3aWNlDQo+
ICAJfQ0KPiANCj4gDQo+IEJ1dCBpZiByZW1vdmluZyBxbGlua19mcmVlKCkgd2l0aG91dCBBbmRy
ZXkncyBwYXRjaCwgdGhpcyANCj4gb2JqZWN0IHdpbGwgbm90IGJlIGZyZWVkLiBJdCB3aWxsIGNh
dXNlIG1lbW9yeSBsZWFrIGFzIGJlbG93Lg0KPiANCj4gIAlxID0gdGhpc19jcHVfcHRyKCZjcHVf
cXVhcmFudGluZSk7DQo+ICAJaWYgKHEtPm9mZmxpbmUpIHsNCj4gIAkJbG9jYWxfaXJxX3Jlc3Rv
cmUoZmxhZ3MpOw0KPiAgCQlyZXR1cm47DQo+ICAJfQ0KPiANCj4gVGh1cywgYmVmb3JlIGFwcGx5
aW5nIEFuZHJleSdzIHBhdGNoLCB3ZSBzdGlsbCBuZWVkIHFsaW5rX2ZyZWUoKS4NCj4gSSB3aWxs
IHByZXBhcmUgYSBzdGFuZGFsb25lIGZpeCB0byBhZGQgcWxpbmtfZnJlZSgpIGJhY2suDQo+IA0K
PiBUaGFua3MuDQo+IA0KDQpIaSBBbmRyZXcsDQoNCkkgdXBsb2FkIHRoZSB2MiBzdGFuZGFsb25l
IGZpeHVwIHBhdGNoIHRvIGZpeCB0aGUgbWVtb3J5IGxlYWsgaXNzdWUgYXMNCmJlbG93Lg0KaHR0
cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtbW0mbT0xNjA4MjA3NTE4MjUyNTImdz0yDQpJIHRoaW5r
IHRoaXMgc2xhYiBtZW1vcnkgbGVhayBpc3N1ZSBpcyBpbXBvcnRhbnQuIEl0J3MgYmVjYXVzZSB3
aGVuIHdlDQpkbyBrbWVtX2NhY2hlX2Rlc3Ryb3ksIGl0IHdpbGwgcmVwb3J0IG9iamVjdCByZW1h
aW5pbmcgZXJyb3IuDQoNCkFkZCB0aGlzIHYyIHBhdGNoIHRvIG1tLXRyZWUsIGl0IHdpbGwgaGF2
ZSBjb25mbGljdHMgd2l0aA0KQW5kcmV5J3MgcGF0Y2hlcyBhcyBiZWxvdy4NCiJrYXNhbjogcmVu
YW1lIGdldF9hbGxvYy9mcmVlX2luZm8iDQoia2FzYW46IHNhbml0aXplIG9iamVjdHMgd2hlbiBt
ZXRhZGF0YSBkb2VzbnQgZml0Ig0KDQpJIHRoaW5rIHRoaXMgc3RhbmRhbG9uZSBmaXh1cCBwYXRj
aCBzaG91bGQgYmUgYWRkZWQgYmVmb3JlIEFuZHJleSdzDQpwYXRjaCBpbiBtbS10cmVlLiBCZWNh
dXNlIG9ubHkgbWVyZ2luZyB0aGlzIHN0YW5kYWxvbmUgZml4IHBhdGNoIHRvIDUuMTANCnN0YWJs
ZSwgd2UgY2FuIHJlc29sdmUgdGhpcyBsZWFrIGlzc3VlIGluc3RlYWQgb2YgbWVyZ2luZyB0aGUg
d2hvbGUgDQpwYXRjaHNldCBvZiBBbmRyZXkncyBwYXRjaCB0byA1LjEwIHN0YWJsZS4NCkhvd2V2
ZXIsIG1lcmdpbmcgdGhlIGZpeHVwIHBhdGNoIGludG8gbW0tdHJlZSB3aWxsIGNhdXNlIHNvbWUg
Y29uZmxpY3RzDQppbiBtbS10cmVlLg0KDQpQbGVhc2UgaGVscCB0byBmaXggdGhlIGNvbmZsaWN0
cy4NCkFuZCBJIHRoaW5rIHRoZSBjb25mbGljdCBiZXR3ZWVuIHN0YW5kYWxvbmUgZml4dXAgcGF0
Y2ggYW5kDQpBbmRyZXkncyBwYXRjaGVzIHdpbGwgYmUgZml4ZWQgYXMgYmVsb3cuDQoNCkkgdGhp
bmsgdGhpcyBwYXRjaCAia2FzYW46IHJlbmFtZSBnZXRfYWxsb2MvZnJlZV9pbmZvIiBuZWVkIHRv
IHJlbmFtZQ0KdGhlICJpbmZvIiB0byAibWV0YSIgYXMgYmVsb3cuDQoNCi0gICAgICAgcWxpbmtf
ZnJlZSgmaW5mby0+cXVhcmFudGluZV9saW5rLCBjYWNoZSk7DQorICAgICAgIHFsaW5rX2ZyZWUo
Jm1ldGEtPnF1YXJhbnRpbmVfbGluaywgY2FjaGUpOw0KDQoNClRoaXMgcGF0Y2ggImthc2FuOiBz
YW5pdGl6ZSBvYmplY3RzIHdoZW4gbWV0YWRhdGEgZG9lc250IGZpdCIgbmVlZCB0bw0KcmVtb3Zl
IHRoZSBxbGlua19mcmVlKCkgYW5kIGFkZCByZXR1cm4gZmFsc2UgYXMgYmVsb3cuDQoNCglxID0g
dGhpc19jcHVfcHRyKCZjcHVfcXVhcmFudGluZSk7DQoJaWYgKHEtPm9mZmxpbmUpIHsNCi0JCXFs
aW5rX2ZyZWUoJm1ldGEtPnF1YXJhbnRpbmVfbGluaywgY2FjaGUpOw0KIAkJbG9jYWxfaXJxX3Jl
c3RvcmUoZmxhZ3MpOw0KLSAJCXJldHVybjsNCisgCQlyZXR1cm4gZmFsc2U7DQoJfQ0KDQpUaGFu
a3MgYSBsb3QuDQoNCg==

