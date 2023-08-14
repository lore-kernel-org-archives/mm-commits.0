Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420C1C001DB
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 21:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjHNVu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjHNVt5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 17:49:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229341BCD
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 14:49:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37EJOsFt023652;
        Mon, 14 Aug 2023 21:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=y7f4wdvwQ8t0sfBwMeZLgVxfVKYO78fm4yG3hEnFacc=;
 b=UDbYeSo2K+K9tY6kzBnvF3dnubzCM5LuuPUQgfGeJzyH0VOG8DJKAryJdf3UOn85uQ7z
 qn3vV22AfAy+wuJ4ArCVvIHBZ9j6O4VDzzxSaecY9y84LWjXbHRo1I0YDi0KuGeo2efc
 yOe2qdDSueS29IoJldsJ32E8M+qwF6oYIcckXkyF+DmwWYQKKiY6Q42x9dD8A1SHXmRt
 0xwMAiTbangkhoKCrVPyHCHY48/2b7sbbMtY3uK4HwMd0NLGr86W3WFXA9ZQihStJE2B
 08FHCxzgMpAy5QJqhsdfpywPKSt0zJ+GiL0GqPx45+HUX0qVnlmasf6Fw0zUzT1DdiCU aQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se2w5umpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 21:47:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37EKr0pc019884;
        Mon, 14 Aug 2023 21:47:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey3up7cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 21:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHbfVlFUZfTOYLz1KysGj78hv6BVZCmvaNjmznwM7cd8xt1PDlWdEJD6xU/05A1TQVlQFCENSFf4agizC4auhdliZes1ykHiVl5/Q+Fb6/qng1gt+NAgcI3zp8E3pxQ7qG9AyboEcZucLWl9uvjwcoJFf+9LOAQGIzO2jTjeyzKvQKQ8PISFb9cnJfWtLoqllSXDvwOrWEUJjIyhktTAmr0hTNSu04Y9vLeMFj+mUo4P2/rPbq9FAa8wVea5eurrJMC8RZv6vJQKESpd1XmaSsUlWqeCZujxBjmnuHAJyvBa3IA6qzx4b4AV3ZkaG8upzPSzUFmhOV9AI1nzUi1lrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7f4wdvwQ8t0sfBwMeZLgVxfVKYO78fm4yG3hEnFacc=;
 b=J89gqdFxSqOBy857KftnWYIGJyOglQyYHpv0/j2gK83mk7ziuPcatCBz218fdRgjLR6F8+aMjDIapJ9g+46+sFGzrj5OhUf3BOOZd0ichtHIL9xxWWo+nVWe4A10O8KFREVXLvPqygoCvN6DBhpvWzhcDTsD4sD29vj4TzObGfMLs1iKWHlAo9hvpAYibQ0wVE4LHm601c6JGYRfldEWOS9PgEzfYh+Od/LxJP0SX168nAh+xJBWyHApcugbwfAGaGDa1xldLo7Kfu1EzLXeibA8H+mEf2TxerC1pIRMQ/qHUvdTEbrLkrJbKvqJhWyDFd0LutbGsrvAzPylbWBRkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7f4wdvwQ8t0sfBwMeZLgVxfVKYO78fm4yG3hEnFacc=;
 b=AYefGTHfP81lNuqdtGqSFOEa0wFwhomA45NqmIU0yfh9oqMWVoKqbQqUX1jI1tc1zzxBvyqIzPIthiyLq2hVNp1ifEdY2B6XH6kd2asI7KvBtvgO8bynkL36cxlNl1WUp3zHtHGlaQqMBtr3+Plsy9lccvuIok8QLx5nwXv2i7k=
Received: from CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
 by PH0PR10MB6957.namprd10.prod.outlook.com (2603:10b6:510:285::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 21:47:05 +0000
Received: from CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::be4f:55e6:89c5:4f57]) by CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::be4f:55e6:89c5:4f57%4]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 21:47:05 +0000
Message-ID: <a32c3104-5516-a7f8-85ff-e687e3e06590@oracle.com>
Date:   Mon, 14 Aug 2023 16:46:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [merged mm-nonmm-stable]
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
 removed from -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, xin3.li@intel.com, will@kernel.org,
        tsi@tuyoix.net, tsbogend@alpha.franken.de, tj@kernel.org,
        thunder.leizhen@huawei.com, tglx@linutronix.de,
        svens@linux.ibm.com, sourabhjain@linux.ibm.com,
        sebastian.reichel@collabora.com, samitolvanen@google.com,
        rppt@kernel.org, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
        paul.walmsley@sifive.com, paulmck@kernel.org, palmer@dabbelt.com,
        ojeda@kernel.org, npiggin@gmail.com, ndesaulniers@google.com,
        mpe@ellerman.id.au, mingo@redhat.com, mhiramat@kernel.org,
        masahiroy@kernel.org, linux@armlinux.org.uk,
        linus.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        dal.ias@libc.org, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, boris.ostrovsky@oracle.com,
        bhe@redhat.com, arnd@arndb.de, ardb@kernel.org,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com
References: <20230812220523.89DECC433C9@smtp.kernel.org>
 <eb3df6ae-c713-9b42-e6ae-562e0cefdd4b@oracle.com>
 <20230814121929.5d93ca775a85732c98aaeda1@linux-foundation.org>
From:   Eric DeVolder <eric.devolder@oracle.com>
In-Reply-To: <20230814121929.5d93ca775a85732c98aaeda1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4531:EE_|PH0PR10MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b8d8d39-6300-472d-c4df-08db9d10004f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVPya5lRh0rqkJ+rZuxrnQ492KROa6dvUZk5HpYJMKRWofpQCPxfMoOX557pCZMosTqNZJ/dur//UwCIoYkecnuDxntQW6q/taau17BCRKBnb+bZHLXqQvFA+Ay08hpkUbES8jR0upEKaGQ4X+U5vOm9VLYxdwcMC21jMLzM9yGRuxnZA90dW9jR3Oz6gnpNGoR/+9yLJRCbtKI7dqd0kpj7UKPm9H7mXsC84HhApf+Ezm56wgZuXV2gDBk7t+lcSwb3efKm8aulNv6eWhe7xim8RU/C91POYmhPcaKJEpFeYQQX1KMN/TppaqL2nPKvKsgg9mGeLYltxJ8F+Kq2PV5FGUZCFk/nUjjCCuGszrs/CY62UOuWAw0pxtZIv2bccViKl8EG5zzJpDGGzUarhR4BY2SkOeJgLGG8vs3zLbYrPmprOV+TYZQP+wM+lmbVlziqCNuNY7j9gL4rcKUCvo5O7hS8I38UUyEQQ4UBqMiNs60uZxFAfMe9OatRKDDdN1/7t5lUrDc8iLvBF1wXqkxqFAs4X/S4jwdEEztYwwxLLn6Whfv6FEl7TdOxOfpHcxOn855V1CbqVvAbVgOyy5zk79502DfjjzIzE/lNUW+WVxp36NxZCAAlccXYzF2nHN6WYKN+lMjj0bbju8VcBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4531.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(136003)(39860400002)(1800799006)(186006)(451199021)(6486002)(6666004)(53546011)(6512007)(6506007)(478600001)(966005)(2616005)(4744005)(2906002)(26005)(83380400001)(7366002)(7416002)(7406005)(66556008)(41300700001)(6916009)(316002)(66476007)(66946007)(5660300002)(8936002)(8676002)(4326008)(86362001)(31696002)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWhMK09pSFNNWWFuUzZ3SGlteHVmZUk0Y3pIakJ3cm5PeEcwVDcxeFVaNmhB?=
 =?utf-8?B?OGdYeU8yTWJmUU5mK0NGc3oyb0twcTFLQUZlWDJlSlg3WDE4aC9xNjFuYkJB?=
 =?utf-8?B?K1dCTFl3eXZEZTZjZDVYbGxwc3pTSjlPZkhycmNHaHpsT3pJUnlqM1ZyeDVn?=
 =?utf-8?B?bEorWXY3KzhuRms4QUJoOEJZWkt5cUpNS3pMUzFTSVdiNnRBT3hmRVBEb1I3?=
 =?utf-8?B?ZDYvRXpTeFF1eXBNZUxOQ293bkllZ24xOFVVS0xteFU3cDlSZWNxc0dkOXU5?=
 =?utf-8?B?MklRVVhwenFoVlZBS0JVTGwvcitmLzFJYmNSNXdkdVI0alkwZ3JzbEdaTmlH?=
 =?utf-8?B?bW9SbDF6dWpwbEkzOHhTd1JWZjNIQzBidzJnOVljV2VSYlhpTldmZzl3cGNF?=
 =?utf-8?B?cnIraFBXVTJhVVNuZmx3QlBWMXhmeS9tSXllMEZwL0d2QlpqTkVlM0k0MEY0?=
 =?utf-8?B?WjhEZWtVTmdnOFFxYjFEbjNPK0dTcVpRZ1p1bEl6QUNLNDRxMVViSlh5TW95?=
 =?utf-8?B?K3lDRm5lalUvTkljaldlMlc3OUNROHJGWUxxZUZtVGMxMEdlbnJVMEgzVC9m?=
 =?utf-8?B?T0VYZ0NoYnI1Y1B1dlUwMXBPVFJ5eEFERFVuYUU3amVZRzBZWlZUK3N0a1ZT?=
 =?utf-8?B?NnpLRkVQdzJ2RVJ4ak5uN1dsTkpqRXJpcHVmZi9oeXRrZVRIa0tXSmV6OFFt?=
 =?utf-8?B?WlVvTzd6THIvZng0RVNhSnBHTjNaYUt3ZkhERnVrUTBkMFc0Znhob1BzZGxC?=
 =?utf-8?B?TkdSclFLUG5TaS8xWVprbE9FZG9NVFpuWWNGTWczRnpETTF4UnBFbWVWN0F4?=
 =?utf-8?B?SHNYZENPQ1lpU2lZeWd3VEd0S0YxS0tPcG0xb2srRzNxNFQra2hhTVJ5RWhl?=
 =?utf-8?B?YU9ySDUvUWUwbi9QSm9IbXFvSGVFb0dHSUR4Zk5DK3VSWlUzZUxsWXhaSWR2?=
 =?utf-8?B?OEY4WHFlZjNkS2dXTlpBMXpBeDJOd1JTRlM5TzdMb2NnTVliUkFxeHVBWURi?=
 =?utf-8?B?TklVNlpiZWlaMEFlU3RzT1FiSUNxQ0ZHbGlMTXpNbEdKOSswY0FmZ3Rjd0c2?=
 =?utf-8?B?VXNtTEdvZ1dnWmFKaEdkYmFkZmhYV3FjQ3FiWk9ZcDFQcmRNaGFRT2xrVTFR?=
 =?utf-8?B?UnVCQzN0UjlXL253M3VLZTJkVlUxQzN5cXpLVzRST01WSGRMelBNcjdnTEVy?=
 =?utf-8?B?eWRIMUxrZSt4SWVqaUdONzNkMXN6bjRCKzhYTGxkS0xKYzJ4RFQxTE92bC9u?=
 =?utf-8?B?UXduR3hFdGNJSmxBNkhWVXVnWUpNK3JNdUZncGtxS0hQWnhtT1NreHpqRzRK?=
 =?utf-8?B?L3lYL1hGWTVtZmV6YlA2aEJ2T1F6TFpLTUU3NlpESEIzNGJmcjNXZWZaeU9t?=
 =?utf-8?B?M1FBdGRYZHRsMXZGMXI5VElmWWs3cGRuYXJlSjNSc0dIUUFURFYvcWhNTnlG?=
 =?utf-8?B?cGdnSkxVQ0o1ZVNERGRGc3hWWWFuVFhQdVdQZGpya0NyaHovNWpENFBNbGFo?=
 =?utf-8?B?Rk9NWGdRdXptcDBsMzFhUFVyM0JtcGdkT3ROWG55N2dpS0ZwcThtNS9FWTFM?=
 =?utf-8?B?VFZqMU5qZ2xSZUp1RjBReGpMVkRaR0V5UzZkdlJvdEhaM3JOTGR5N2lKL0Jl?=
 =?utf-8?B?WTVtRENDZVNuQ0NqM3hiYmtEWGRuWnVpbGE5MUtTbzMwYzQ5M0VLaTZMZEY3?=
 =?utf-8?B?UHh4YU5STFpya2NwbVRRV00zd1kyaml1NjZqTVkxbjFuM2xsb2tzdEtlby92?=
 =?utf-8?B?TFpqaHlyVzZwdmg3K2FkZmVWbkxTRnFRR3NSOStmOWZSZ1B5WmFOWFBaZEcv?=
 =?utf-8?B?Rzd4Uko2VHdBUDM1a1BXckRDTmxqR1l2V0xYMk1wQm5QZEtWbExIcUR5QTJ0?=
 =?utf-8?B?eGtqMVM3STZBVVUyb1dIMkdLVC9IbUFuclNjRTFoOEIxbjRjdGxNL2J3dzZv?=
 =?utf-8?B?M2g5eWtLS0duc2VDZVg4ejR2bnZSVlpGamozeU1sLzFpY056V2N3MUI2UWR5?=
 =?utf-8?B?UW9wbVRCY0F2TEprNVZZOWxDcFNrU1VvWVQzR3VnbVQyMmIrbGo0RWprMzVS?=
 =?utf-8?B?UkdOZmZlWmowZDRXUEpMZDYxU2NiYTdFTlVFSG94ejd0UnZuWXFkWTlUeHFW?=
 =?utf-8?B?bnhrSGMxbVcya2xPSWpxQjk2TzRtZ01rbE5uQ2Vpb0d2M2pRZVNLcXE3NGow?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q21BeE5yQ3VkUUZOS0hXVGVJQ092WlpsYURENjdkMjRjY3dyMzREZ1RHQ1dr?=
 =?utf-8?B?Z2xFYlcvODVObnNRb29nODlmOUxsWjlxWHNFVGxEWGV6VlplRWhRSlhNOTVP?=
 =?utf-8?B?SGRkTVVYYm1PeHhyWi9TcytMOWZLRXVSUTlpZXdod1JCUWM0dHUwSzZYWXYy?=
 =?utf-8?B?ZHZ2Y0tQeXNMMFAxNmd2UCsxS2ZNRDZHeGhvM1FoS2FLbnNkaDBUY3diK3d4?=
 =?utf-8?B?RnJhcWRCVWRCQmVTTGlmRlh3VTJzRkZJM2dsUzNESE1pM1dFMktXWVVZN0w5?=
 =?utf-8?B?d3dncUtKQ1AwODlySDJxY3IzREpqRnR0OEhEZ0JKMHBIaDlkQzZVZWsxQmNQ?=
 =?utf-8?B?ejdnZWh6Um5CMlFaK0JVNmdDQ2RERXZTMXNuYmhtMEtrb0RtcFZReHRlRi9H?=
 =?utf-8?B?WEhZRVo4RTloalZTVlczYnYwSmpOYXBKNWZBZndRUW00aDFnTUExZjEvZ3Mz?=
 =?utf-8?B?WUNiV05HYnIydmdabTU2aXpEbVZVdmZ0R1VOQjkzVE5xK2MwdlVhNmdaWEhw?=
 =?utf-8?B?T3owSUtHL05tZWw4SGpBeU1KekxGdzB2TkRjejB3Q2ZLTVZJQVB0aU51bVJm?=
 =?utf-8?B?bTRJNmZZdW1BcXJQWUFhZFBpZzBza1l5MTVJQkhmZ2ZWWVM4UHo2V1AxeTRn?=
 =?utf-8?B?L3h1Y1E2V3RMVHpjQ1JxbUI4QWdkVWpLQW9iWlFmSUxxQkQySWREaTROVnBC?=
 =?utf-8?B?RE9wK0FOQW8vd1owczJmTTM5WkRzS00zOFZySVVBYUJQWExSWVVOV3F4Yi9s?=
 =?utf-8?B?WHkxNTlQV3pqZzJoMzlIREREbFJjdSs0bDFBeXIwUTFJdGpSVHBXNjAwT0ZV?=
 =?utf-8?B?Z3VYQkp3NFVEUVBoM1ZMQUZRbjVKQ2FjVEZJY1lkcjN6dkhjT3pqYkVvVmpx?=
 =?utf-8?B?c2h4b2V2T0ZyTzhoalo2UDJKcGZOZG1QK0M3aVBrVk1SdjJ1Rldnc0ZCZmdq?=
 =?utf-8?B?bXFXOGE1UDYrNGJ5QjJ2OUg2ZUROZXJFdlpRMTlWazlZcEFneVlaMVkyU21t?=
 =?utf-8?B?cmJmZWFCZm52QjQwRDVoSFpUNm5ubEt4ZjBtSkp4eFlaaFA3aERqNCswRDBM?=
 =?utf-8?B?bTJlYXM1dzZmaFFEVGJadmdXTFJDVC9SWHBGSTVrdzljdndHNlhlYnBTbHdt?=
 =?utf-8?B?L1BNcG9iRy9KSUJjNUxmTFBnbkZLVmhWdndpeDEyakxlU0s3TDZqMXcxSzRS?=
 =?utf-8?B?YjZ1UFdNS1U5YTdsalE2U1VtOTNtRThUeG9wYVZHWVRScURqWHhBeDVucHBj?=
 =?utf-8?B?UXpwWXllaHF4TmVaMDVzWVRyL1VQOFJ6MExGVkJLb1phQ0hCeEFDdjA5ejlu?=
 =?utf-8?B?dmJvVDNxcVBaWHJKY2tiUlowS3REbDFyRWxFTERyNUZTVmd0emlFbUovVy9p?=
 =?utf-8?B?Z3BQVGltL1NMRERuK3VVdVRaa1UrbmZPODUwbjZBdXYvYytIMG5jOGlsdldy?=
 =?utf-8?B?T0g4MFR2eldVSE8rd0JNY2ZaOWpSUzhhSVRRZUlFWDdtby85bk1NeGE1ZWxt?=
 =?utf-8?B?eDJ6ejVLWmRoQVV1bkJTQlhUYXJiZ2FZUTVmM3dYZ21oM05mZnBTWWxJM2hT?=
 =?utf-8?B?UkwvZkVTVzB5NS9LV3pyNEdtWDlxRXUxZUtCdTQ3V0JaeFprK1hkN056R3U0?=
 =?utf-8?B?dDZ4d1YrSVAwdFV5VW8zZ0xzTmRTZWZaUzFBeitXbmxiOTgrakZadzNwTWM0?=
 =?utf-8?B?WHBoR2VpTzE2YkpmdTNTaXN5MmVFYnNLVTNhYXpZUjVzTHY0bHIzMGoyS0I4?=
 =?utf-8?B?WE95Q3pxYm1wbzI0N2hGbHYyZ1pRZzMwTkFiaG1FY3MxR1NBNUFaamE1WVpC?=
 =?utf-8?B?RXFxczkxdnZSR0JhYnFKckVxNWNjVFROVzN4VWl3dTNwc1IwYjh6d2NlN3FI?=
 =?utf-8?B?WVhjYkRLR0Vhc2FFVzBUcC9rd2lxY0ZUUTV5THMwU1Y5VHltT1ZJd1BIQlJZ?=
 =?utf-8?B?TFh0azhib3pwVGVIZHduOUYyUjZTNFFmRlJEdGE1YWNha3h4R2NHNUNIUmhF?=
 =?utf-8?B?a2tqbDFCSG55YVZpczg4TStLYTNOTm96V3lVcEpXQWU3cUpsOVFOTC9VZWhi?=
 =?utf-8?B?SU9hb21FZTJrbHg3THc1Zm5YREt2SUE3OVhhUnJZZEU0RGJUS25wVkhWY3Zw?=
 =?utf-8?B?Q2VmTFFaS2ZnYkJSdGs4amxXVE5XTTVHT1ZhbDB6cit6U2lHcTNPcmhWck5u?=
 =?utf-8?B?ZFk4cXBtYVJsUldYUjQ4Z2dhUlo2L2g5QUJ0cUV0TDAyZ2ZiTkVobi9ENFpM?=
 =?utf-8?B?NkdtQWRXamtBVXFSdFlnYWVyUFhIOWFQN254NjRlYUlGUmp2ZE55Y3A1TWk5?=
 =?utf-8?B?cDdoc2gvblh2Mk1NVzR6bThCNHg0ZWd4VFNYSEU3M3BnWWpHYjcxYkM1d3Zq?=
 =?utf-8?Q?GCSVWJ7JDlyDVM2Ix2cG/RF87qkVeyO6yM7JrxOm6i1C9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: cipV0jU6w0t3nFS3azf/qURrkt0smIbXzzl06jhbKFpIRudP2qZW03UW143fRuJVi9aVRrvEO/n3K47xbWtX2qP4pVi6MPHaboG+pyQp7CYwq5CgEMGh0x3TNgjanXbjEAxtpJE4SSZcQzF2mxqDx9uDiZU41hlQUS1NhVvIdRUkRQIPV5sGDpMWZR8EtykT19yA/i6q7vhST0AtMI9jl6YGuPDfuxALDfwzUqVjJD7+xYwVHDOsJJbMcZFfCmXiehRib5Cz5pAeEg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8d8d39-6300-472d-c4df-08db9d10004f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4531.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 21:47:05.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hsNKGdE0amWR7OtaO6bQ5WVutxKr6voy4jO4tE5+ldbDxoBK70F9+lOo1Gba3RelUXxtrSSgjE7ik/aRTbTo+haxb3c6sGtz6d/iCMkRNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-14_18,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308140200
X-Proofpoint-ORIG-GUID: 7hO2iYtYJJJfoUOFEaPzMxksU3wMEBt8
X-Proofpoint-GUID: 7hO2iYtYJJJfoUOFEaPzMxksU3wMEBt8
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 8/14/23 14:19, Andrew Morton wrote:
> On Mon, 14 Aug 2023 07:08:34 -0500 Eric DeVolder <eric.devolder@oracle.com> wrote:
> 
>>   From automated email on Friday, I see that v27 of the crash hotplug series was picked up, thank you!
>> I have been watching the mm-nonmm-unstable branch and I do wonder when that v27 will show up there?
>> It still has v26 which has build issues related to PROC_KCORE.
> 
> It turns up when I type "git push", which I did yesterday ;)
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch

I am terribly sorry! I made a mistake in my script and accidentally reposted v26 as v27.
I have posted v28 which is the version that has the corrections for PROC_KCORE build
failures.
I am so sorry for the churn!
eric
