Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E469C12002
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 01:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F66613CC
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 01:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGOB1n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 21:27:43 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:47236 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231186AbhGOB1m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jul 2021 21:27:42 -0400
X-UUID: 7131063873964a54bd127444af7d25a0-20210715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AxzIDN0HOSdn1TQhjQMRNc+POyCe7MlazD2QusZPWqs=;
        b=G7M+zAu+pDfYkwYpwOtSDwoVByBBi6IIHbe+v4k0PXcHcjF5L13Pn0yHWxvXsJCcYS5Q1ACuFs+2xLzx1oT+8eP3mQzS9m97rgLLJVK0ePiUOI9j3Brj3lYTnV0peYnbL54rFzV2G7/PJlLxeK+2/+LLwHRiemMC713XPqlfm8U=;
X-UUID: 7131063873964a54bd127444af7d25a0-20210715
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <yee.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 163917866; Thu, 15 Jul 2021 09:24:46 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 15 Jul 2021 09:24:44 +0800
Received: from mtksdccf07 (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 15 Jul 2021 09:24:39 +0800
Message-ID: <8ce7a6fd627cfbb1c8db8db0eeecbf64830dad61.camel@mediatek.com>
Subject: Re: + mm-move-helper-to-check-slub_debug_enabled.patch added to -mm
 tree
From:   Yee Lee <yee.lee@mediatek.com>
To:     <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <willy@infradead.org>, <ryabinin.a.a@gmail.com>,
        <nicholas.tang@mediatek.com>, <Kuan-Ying.Lee@mediatek.com>,
        <glider@google.com>, <dvyukov@google.com>,
        <chinwen.chang@mediatek.com>, <andreyknvl@gmail.com>,
        <elver@google.com>
CC:     <surenb@google.com>
Date:   Thu, 15 Jul 2021 09:24:39 +0800
In-Reply-To: <20210706204228.UHkIR%akpm@linux-foundation.org>
References: <20210706204228.UHkIR%akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCk5vdCB5ZXQgc2VlbiB0aGUgcGF0Y2hlcyBpbiBtbSB0cmVlLg0KQ291
bGQgeW91IGhlbHAgdG8gY2hlY2sgdGhlIHR3byBwYXRjaGVzPw0KDQoNCmh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xrbWwvMjAyMTA3MDUxMDMyMjkuODUwNS0yLXllZS5sZWVAbWVkaWF0ZWsuY29t
Lw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIxMDcwNTEwMzIyOS44NTA1LTMteWVl
LmxlZUBtZWRpYXRlay5jb20vDQoNClRoYW5rcywNCg0KQlIsDQpZZWUNCg0KT24gVHVlLCAyMDIx
LTA3LTA2IGF0IDEzOjQyIC0wNzAwLCBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnIHdyb3RlOg0K
PiBUaGUgcGF0Y2ggdGl0bGVkDQo+ICAgICAgU3ViamVjdDogbW06IG1vdmUgaGVscGVyIHRvIGNo
ZWNrIHNsdWJfZGVidWdfZW5hYmxlZA0KPiBoYXMgYmVlbiBhZGRlZCB0byB0aGUgLW1tIHRyZWUu
ICBJdHMgZmlsZW5hbWUgaXMNCj4gICAgICBtbS1tb3ZlLWhlbHBlci10by1jaGVjay1zbHViX2Rl
YnVnX2VuYWJsZWQucGF0Y2gNCj4gDQo+IFRoaXMgcGF0Y2ggc2hvdWxkIHNvb24gYXBwZWFyIGF0
DQo+ICAgICANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vb3psYWJzLm9y
Zy8qYWtwbS9tbW90cy9icm9rZW4tb3V0L21tLW1vdmUtaGVscGVyLXRvLWNoZWNrLXNsdWJfZGVi
dWdfZW5hYmxlZC5wYXRjaF9fO2ZnISFDVFJOS0E5d01nMEFSYnchMWZCUG9kVGNCV19kZ1Utd0dY
SWo1dGN0UFdwVWJLTnRvVDJWamFvTXBTSk54RXhoY0hLVFdpMEFzbHl4S1pRJA0KPiAgDQo+IGFu
ZCBsYXRlciBhdA0KPiAgICAgDQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczov
L296bGFicy5vcmcvKmFrcG0vbW1vdG0vYnJva2VuLW91dC9tbS1tb3ZlLWhlbHBlci10by1jaGVj
ay1zbHViX2RlYnVnX2VuYWJsZWQucGF0Y2hfXztmZyEhQ1RSTktBOXdNZzBBUmJ3ITFmQlBvZFRj
QldfZGdVLXdHWElqNXRjdFBXcFViS050b1QyVmphb01wU0pOeEV4aGNIS1RXaTBBMEFxazlxbyQN
Cj4gIA0KPiANCj4gQmVmb3JlIHlvdSBqdXN0IGdvIGFuZCBoaXQgInJlcGx5IiwgcGxlYXNlOg0K
PiAgICBhKSBDb25zaWRlciB3aG8gZWxzZSBzaG91bGQgYmUgY2MnZWQNCj4gICAgYikgUHJlZmVy
IHRvIGNjIGEgc3VpdGFibGUgbWFpbGluZyBsaXN0IGFzIHdlbGwNCj4gICAgYykgSWRlYWxseTog
ZmluZCB0aGUgb3JpZ2luYWwgcGF0Y2ggb24gdGhlIG1haWxpbmcgbGlzdCBhbmQgZG8gYQ0KPiAg
ICAgICByZXBseS10by1hbGwgdG8gdGhhdCwgYWRkaW5nIHN1aXRhYmxlIGFkZGl0aW9uYWwgY2Mn
cw0KPiANCj4gKioqIFJlbWVtYmVyIHRvIHVzZSBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc3VibWl0
LWNoZWNrbGlzdC5yc3Qgd2hlbg0KPiB0ZXN0aW5nIHlvdXIgY29kZSAqKioNCj4gDQo+IFRoZSAt
bW0gdHJlZSBpcyBpbmNsdWRlZCBpbnRvIGxpbnV4LW5leHQgYW5kIGlzIHVwZGF0ZWQNCj4gdGhl
cmUgZXZlcnkgMy00IHdvcmtpbmcgZGF5cw0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IEZyb206IE1hcmNvIEVsdmVyIDxlbHZl
ckBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBtbTogbW92ZSBoZWxwZXIgdG8gY2hlY2sgc2x1Yl9k
ZWJ1Z19lbmFibGVkDQo+IA0KPiBNb3ZlIHRoZSBoZWxwZXIgdG8gY2hlY2sgc2x1Yl9kZWJ1Z19l
bmFibGVkLCBzbyB0aGF0IHdlIGNhbiBjb25maW5lDQo+IHRoZQ0KPiB1c2Ugb2YgI2lmZGVmIG91
dHNpZGUgc2x1Yi5jIGFzIHdlbGwuDQo+IA0KPiBMaW5rOiANCj4gaHR0cHM6Ly91cmxkZWZlbnNl
LmNvbS92My9fX2h0dHBzOi8vbGttbC5rZXJuZWwub3JnL3IvMjAyMTA3MDUxMDMyMjkuODUwNS0y
LXllZS5sZWVAbWVkaWF0ZWsuY29tX187ISFDVFJOS0E5d01nMEFSYnchMWZCUG9kVGNCV19kZ1Ut
d0dYSWo1dGN0UFdwVWJLTnRvVDJWamFvTXBTSk54RXhoY0hLVFdpMEFiV3hJbVFzJA0KPiAgDQo+
IFNpZ25lZC1vZmYtYnk6IE1hcmNvIEVsdmVyIDxlbHZlckBnb29nbGUuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBZZWUgTGVlIDx5ZWUubGVlQG1lZGlhdGVrLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBN
YXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IEFsZXhhbmRlciBQb3Rh
cGVua28gPGdsaWRlckBnb29nbGUuY29tPg0KPiBDYzogQW5kcmV5IEtvbm92YWxvdiA8YW5kcmV5
a252bEBnbWFpbC5jb20+DQo+IENjOiBBbmRyZXkgUnlhYmluaW4gPHJ5YWJpbmluLmEuYUBnbWFp
bC5jb20+DQo+IENjOiBDaGlud2VuIENoYW5nIDxjaGlud2VuLmNoYW5nQG1lZGlhdGVrLmNvbT4N
Cj4gQ2M6IERtaXRyeSBWeXVrb3YgPGR2eXVrb3ZAZ29vZ2xlLmNvbT4NCj4gQ2M6IEt1YW4tWWlu
ZyBMZWUgPEt1YW4tWWluZy5MZWVAbWVkaWF0ZWsuY29tPg0KPiBDYzogTmljaG9sYXMgVGFuZyA8
bmljaG9sYXMudGFuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0
b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiANCj4gIG1tL3NsYWIuaCB8
ICAgMTUgKysrKysrKysrKystLS0tDQo+ICBtbS9zbHViLmMgfCAgIDE0IC0tLS0tLS0tLS0tLS0t
DQo+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQ0K
PiANCj4gLS0tIGEvbW0vc2xhYi5ofm1tLW1vdmUtaGVscGVyLXRvLWNoZWNrLXNsdWJfZGVidWdf
ZW5hYmxlZA0KPiArKysgYS9tbS9zbGFiLmgNCj4gQEAgLTIxNiwxMCArMjE2LDE4IEBAIERFQ0xB
UkVfU1RBVElDX0tFWV9GQUxTRShzbHViX2RlYnVnX2VuYWINCj4gICNlbmRpZg0KPiAgZXh0ZXJu
IHZvaWQgcHJpbnRfdHJhY2tpbmcoc3RydWN0IGttZW1fY2FjaGUgKnMsIHZvaWQgKm9iamVjdCk7
DQo+ICBsb25nIHZhbGlkYXRlX3NsYWJfY2FjaGUoc3RydWN0IGttZW1fY2FjaGUgKnMpOw0KPiAr
c3RhdGljIGlubGluZSBib29sIF9fc2x1Yl9kZWJ1Z19lbmFibGVkKHZvaWQpDQo+ICt7DQo+ICsJ
cmV0dXJuIHN0YXRpY19icmFuY2hfdW5saWtlbHkoJnNsdWJfZGVidWdfZW5hYmxlZCk7DQo+ICt9
DQo+ICAjZWxzZQ0KPiAgc3RhdGljIGlubGluZSB2b2lkIHByaW50X3RyYWNraW5nKHN0cnVjdCBr
bWVtX2NhY2hlICpzLCB2b2lkDQo+ICpvYmplY3QpDQo+ICB7DQo+ICB9DQo+ICtzdGF0aWMgaW5s
aW5lIGJvb2wgX19zbHViX2RlYnVnX2VuYWJsZWQodm9pZCkNCj4gK3sNCj4gKwlyZXR1cm4gZmFs
c2U7DQo+ICt9DQo+ICAjZW5kaWYNCj4gIA0KPiAgLyoNCj4gQEAgLTIyOSwxMSArMjM3LDEwIEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCBwcmludF90cmFja2luZyhzdHJ1Y3QNCj4gICAqLw0KPiAgc3Rh
dGljIGlubGluZSBib29sIGttZW1fY2FjaGVfZGVidWdfZmxhZ3Moc3RydWN0IGttZW1fY2FjaGUg
KnMsDQo+IHNsYWJfZmxhZ3NfdCBmbGFncykNCj4gIHsNCj4gLSNpZmRlZiBDT05GSUdfU0xVQl9E
RUJVRw0KPiAtCVZNX1dBUk5fT05fT05DRSghKGZsYWdzICYgU0xBQl9ERUJVR19GTEFHUykpOw0K
PiAtCWlmIChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZzbHViX2RlYnVnX2VuYWJsZWQpKQ0KPiAr
CWlmIChJU19FTkFCTEVEKENPTkZJR19TTFVCX0RFQlVHKSkNCj4gKwkJVk1fV0FSTl9PTl9PTkNF
KCEoZmxhZ3MgJiBTTEFCX0RFQlVHX0ZMQUdTKSk7DQo+ICsJaWYgKF9fc2x1Yl9kZWJ1Z19lbmFi
bGVkKCkpDQo+ICAJCXJldHVybiBzLT5mbGFncyAmIGZsYWdzOw0KPiAtI2VuZGlmDQo+ICAJcmV0
dXJuIGZhbHNlOw0KPiAgfQ0KPiAgDQo+IC0tLSBhL21tL3NsdWIuY35tbS1tb3ZlLWhlbHBlci10
by1jaGVjay1zbHViX2RlYnVnX2VuYWJsZWQNCj4gKysrIGEvbW0vc2x1Yi5jDQo+IEBAIC0xMTks
MjUgKzExOSwxMSBAQA0KPiAgICovDQo+ICANCj4gICNpZmRlZiBDT05GSUdfU0xVQl9ERUJVRw0K
PiAtDQo+ICAjaWZkZWYgQ09ORklHX1NMVUJfREVCVUdfT04NCj4gIERFRklORV9TVEFUSUNfS0VZ
X1RSVUUoc2x1Yl9kZWJ1Z19lbmFibGVkKTsNCj4gICNlbHNlDQo+ICBERUZJTkVfU1RBVElDX0tF
WV9GQUxTRShzbHViX2RlYnVnX2VuYWJsZWQpOw0KPiAgI2VuZGlmDQo+IC0NCj4gLXN0YXRpYyBp
bmxpbmUgYm9vbCBfX3NsdWJfZGVidWdfZW5hYmxlZCh2b2lkKQ0KPiAtew0KPiAtCXJldHVybiBz
dGF0aWNfYnJhbmNoX3VubGlrZWx5KCZzbHViX2RlYnVnX2VuYWJsZWQpOw0KPiAtfQ0KPiAtDQo+
IC0jZWxzZQkJLyogQ09ORklHX1NMVUJfREVCVUcgKi8NCj4gLQ0KPiAtc3RhdGljIGlubGluZSBi
b29sIF9fc2x1Yl9kZWJ1Z19lbmFibGVkKHZvaWQpDQo+IC17DQo+IC0JcmV0dXJuIGZhbHNlOw0K
PiAtfQ0KPiAtDQo+ICAjZW5kaWYJCS8qIENPTkZJR19TTFVCX0RFQlVHICovDQo+ICANCj4gIHN0
YXRpYyBpbmxpbmUgYm9vbCBrbWVtX2NhY2hlX2RlYnVnKHN0cnVjdCBrbWVtX2NhY2hlICpzKQ0K
PiBfDQo+IA0KPiBQYXRjaGVzIGN1cnJlbnRseSBpbiAtbW0gd2hpY2ggbWlnaHQgYmUgZnJvbSBl
bHZlckBnb29nbGUuY29tIGFyZQ0KPiANCj4gbW0tbW92ZS1oZWxwZXItdG8tY2hlY2stc2x1Yl9k
ZWJ1Z19lbmFibGVkLnBhdGNoDQo+IA0K

