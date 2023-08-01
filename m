Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864EFC00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 16:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjHAQiY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 12:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjHAQiX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 12:38:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4FC1FE8
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 09:38:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371BB8aU027058;
        Tue, 1 Aug 2023 16:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qK8+tkBkKsuZjo7RepIBXUBWfF5qEQQswsgJvck9RLA=;
 b=kdewbkWzAjh1uLhXS6aPGTluaiGMZJ1PYoxLOROQdcCsqjBEpU+ACwp2VtkaHI7KEqgE
 4PCqGvMvQVRuKfTZ/KfpsNyTIPyOsRARIP5daC9M7Cxa0oF9/Qouof5QXFe4t/LWN9SX
 48llFf068IVNaS58RkT0kCyWewiYYu4gQ5ZzjysrdRx5lJ/5qk3UOoPe6fR4Io2kL2s6
 O9qlWg0ufgwxCDKnbJN9e6gTT8/0LyYVbwPoiENpLKESEbVZ+xpQ+xVnRDe1v+alFLV1
 ZWaSz9ITjIGrV1kBUXp6G/ce5yn/yTJYZxpq82+rxbkwHrVAPvV8mhc46gZjftVtzIKZ 9Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tnbdbk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Aug 2023 16:30:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 371FcTD9038121;
        Tue, 1 Aug 2023 16:30:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7d66bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Aug 2023 16:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ6gXrcveUCFD8hYWyko0c2ogcmc/cYbsMwg70kE1tu412aD1pbb01QXS2xZsT+7QRDt6EMNnDvip6My+VCHflOoTkJiqkFgeB33URBXn3KV0cC/98DfbuyYIJ/ObJfrlU/LkdKzvsOTFdZyyYL0ewWFayooHw4SvTNA8y3fwgYPZo/MFvpJcKsCLQbY4+pzqDpbRDGYqFJqjveenpEHMp4XdHl+FtF+eSHruDVfG+C3C4gCHueWhI25S3PHtPA2VBvKtApYS6HbtKRF7mG98iSv44wSZLlg0FwBkrh1qXMzVSfINLyZk4SUf6lWjlsVXJqg7rjVa3LVmZGyG39h7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qK8+tkBkKsuZjo7RepIBXUBWfF5qEQQswsgJvck9RLA=;
 b=jbftiUbD85qc04RDoZmqdztTEZePHADQKKKEEnuQh+elkPS2hulC6MqF/D/szEDhwYex6F0836busHgBLOpo300AEHi5K/vtDAM6q5Ep8CZjzx9aEsLp4Argv9NZDvSCCQ/GQe6M5JYkwM6JSNRG5vnoRcCS+rBg6S16Ds/fAOsPVTpZX0GwwrS+dhcwkzf79ja8CnCc2RvoThUJWHmUzvVPHg/3g5PP7+HOJENQJR5cEKwlHPZiQ3H6LoFQu5RD7MnZ2lTGFXLJjDDMputw/LaH4QZZPesnodEY5v3JD8sTe9eYKMcd7uTWdlHediDTYMsBc/ZMNXWCREmejXAV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qK8+tkBkKsuZjo7RepIBXUBWfF5qEQQswsgJvck9RLA=;
 b=IGgvK7sPTwrIqE5I9oFrjx8TkQ3Tdr7/jghnQS0+MpsZQH7jrhJ1IPfgjSQSTTKTWq4GUyPgq8EUJgKNRJf8OnLa9mJYXLcKrdIHGLgUTYxuMj6C8axteuqZft8tS4jchzY3PgAQaahn0kj0Sw15n0LwtXQV2txbWh8yrwG6rO8=
Received: from CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
 by CO1PR10MB4660.namprd10.prod.outlook.com (2603:10b6:303:6d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.41; Tue, 1 Aug
 2023 16:30:28 +0000
Received: from CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::a7b5:113e:6f8c:5028]) by CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::a7b5:113e:6f8c:5028%4]) with mapi id 15.20.6631.042; Tue, 1 Aug 2023
 16:30:28 +0000
Message-ID: <32e8593c-87df-afab-8610-7d3cec64cbba@oracle.com>
Date:   Tue, 1 Aug 2023 11:30:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: +
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com,
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
References: <20230712191528.70CBFC433C7@smtp.kernel.org>
From:   Eric DeVolder <eric.devolder@oracle.com>
In-Reply-To: <20230712191528.70CBFC433C7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0063.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::12) To CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4531:EE_|CO1PR10MB4660:EE_
X-MS-Office365-Filtering-Correlation-Id: 854076b6-54f7-4a99-a36f-08db92ac9d94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w12M97ACzC3dOvWVQNeZ2lPn7bTqs6ibom6I1qCogLuCdlm6vBZUCDTi46BbiZkB0Emrsu82Dl5xVNO6NcC2x8G/G49CeorgNzaFJX3Vz2nvGLc186S75pC+CcZ+PBubWEsiz5QHpFuDFUTdyr1Bxn5P4rj8PrdRFJDCpmw9eyw/aQ8AKbHw5gXEW/MgfX9WDbA1NpxN5/shDSIWSFnFjlsENQqElKQXCJ49khptJ5ekw+IsJNIiPEeKmY5rmi6lQK+N8dtPMdTo7tlaXLuqztKuDxe6Qa8PZQgMcaTxa0gP2oCdiNt85EvLLol2kRCsLM8r2JR97F5I7b96OvXaHAzwUiy6L1KSsxdo6HSmTnOc7wXn89/KNIzgni2xmbHsI/8CXIoewu+sGJU1Ups7EovKOlW/fF2gjVFBU4XAXUiW0bohCKvQmwY+wDxMME8qefZNH2WhzcLHttVqTsf+4uPlc2ajqh4/v3Pju18ACmL4j2Ma3sw3xMK96cyJq6Ue+TSr+5Fh+c/OhpzFjxlNzWT+FfFeC7JgzKMEIn6vpiYElNmU5ydLfVBb89dImh7GaeyAvcwDkT9YdFK/Y2FcCorSHml72Bpi9G+UONuP2gLgSe9jR6tFP8SBdrT3ZXnfihLFRG6Qoj8cRJsTtHVQeZXqRP5ze/A3OW9crAxgQf27WpXu6tG3gYODd1gtoeTR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4531.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199021)(966005)(6512007)(6486002)(36756003)(53546011)(2616005)(26005)(6506007)(83380400001)(186003)(66574015)(66946007)(66556008)(7416002)(7366002)(921005)(41300700001)(7406005)(86362001)(38100700002)(31696002)(66476007)(5660300002)(8676002)(8936002)(1191002)(316002)(31686004)(2906002)(6666004)(66899021)(478600001)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cENkdkYxZkhUTG10ZGlVZTJBaDQ4cTZXelBIdk1ld0tPaE5hOVk0UFQ2NEZQ?=
 =?utf-8?B?TkNNUXJKK1JJcnRMdmtrYWoxcmE1TGhnSy9DVnhaa0RuSjQ5TlFQM296SVdo?=
 =?utf-8?B?QXp0b0JiMW15NmNDTFFFREZXRTluUFh0Q0F6Mk9PbWxsT2Q1elVhUVcyNWlr?=
 =?utf-8?B?M0NqSGlsSzFlWWlRL3hkV2xoaVBvM09TdVVSd0daVjdHQkhiQWlKMDZteFZh?=
 =?utf-8?B?QVVoR2dDK1VxOVZuSnFNZGNMSXgzRjNCQkFWb3VlUXgzdFFxalZ4ZDhaYlNT?=
 =?utf-8?B?MTJHYzRQeGRuSTZPanp3b3JaTmFtTGg5Wk9TclpjQ1NoTGk5bTIwanZsMXoy?=
 =?utf-8?B?SWpHUXVwQzl6YzM4ZlJUbW1jc05EQjdhN05sQnBYQXRDcUFTMFVDYWh5ZXJn?=
 =?utf-8?B?eHlRMXR5Z21OVk50TVBIWDlMMFFIbGZVMjJVdjh3UWtHMlh6bHZDRWQ1N3RC?=
 =?utf-8?B?akphTXZoQ0x0NXVCSVRxZHg0L0FwM2w5K3dsYmdydFg4bENERDRtRU9hTDEv?=
 =?utf-8?B?NnlwblduZVY5SDlKWVhvelJNcHZQYStYRHJVYjZGblN2Z2FUTWVmVm9OdG9v?=
 =?utf-8?B?cnRjQ0ZrMysyanFvS1BQeUEzTVlWcXJHTUw3VTJidTVvVEZmTDlCVzlpNGdL?=
 =?utf-8?B?SFV3RVFIV3FiRzJ5OVVDUU5aOGVxZmtETE5JT3g4NlNnekZUL3NrZWY0Z2tE?=
 =?utf-8?B?WWJ6bHVEa1lkZTlLSDZ6b3FvOWlpd1RkR3FORWd6WDNGVTVsNWREZWJnSzh6?=
 =?utf-8?B?L0lZY0svaFE5WjR0RWRJOWw4WWkwZUNlL3JLTUtuSDZickIwbGRZMW1UVndv?=
 =?utf-8?B?TTNsaGJkZ0Rxa05YQ0wxMStBdmZzV2NBQS9BaldYdjRkL2VzaUt5bm04VXRZ?=
 =?utf-8?B?ZCtnNUhRaTJndDhNSFJDSjlxQWx2alF6cDc5ZE5rQjZsRW5xV1lvR01CSGNN?=
 =?utf-8?B?T1NSVlI1YUp4Q0xwd0tPU0FQb3FwcnVmMDgrYVZEc1NDSXYrcitoUUZ6VHFx?=
 =?utf-8?B?YWNPT2tqUGJ3NC9RK1YwZnM4eU5sR3owdnZpSDUwcEtwQ2h4enJNZWR4RTVh?=
 =?utf-8?B?R1ludVg5TXZsZ3FUTFN3dXRpUFJIVGdEbE1wbWdUTytlZXk1TEFQNXZDZnF4?=
 =?utf-8?B?aWVKTmJuY2tiWHBIMlJkb1ZIdXlBWERoN2RrSmora1ZWRlN4cHlZeXhCSlZY?=
 =?utf-8?B?ME4rbThQSzh6Rk82Q29TSzkwVE4vWHdocVgzSW5jYVRIcE80Q0VzSG15dktK?=
 =?utf-8?B?RVFZcGxhL1dSbWFwa09KVC9SU054WnZLMXpvbVBUcko3ZTk5bUtiSkEzN2RV?=
 =?utf-8?B?L2xHT0Nzb1lTUU1rR3RZTER2U1VHNXZEWXRUZ2RydTlIbmhuc2drY1VaV0g0?=
 =?utf-8?B?U2w2alZhbW9Ua29WeWVPQXBQVnFlWDVWSklHMHg1WDFsYXhyMG9nOTdXeTMr?=
 =?utf-8?B?dVBJV0l4d3lZYVNSRGtsK2JwSzgxRTZTaW85KzcxVTVLUGVzVC9La2Nxbjhy?=
 =?utf-8?B?MGV3clVMdFovVjJXYlFRL3RBZE03QVowL0VldmFpelg1VTZqMmhYcitVbUJQ?=
 =?utf-8?B?Zm5JK2dvOGoxcktVYVlPWUdIaFpxSkhJZjRFcVpnSnF5YUg1T0FyZ3E3TFcy?=
 =?utf-8?B?cWdNd2dJckx2V3YvMytLcGNFNTFvc1ZKSVpyMmZWTjQrYlh0WVV0aWdWVHJt?=
 =?utf-8?B?UDNiQ0pBWU1odDJjaU9sU0orUTAzeVozK0s3WjlndDdDM2hyUkNQU1hHdFFE?=
 =?utf-8?B?ZGpMdW13SitkUW9lNjM1aTRLbXQ1dS9xbXBaUE4venBicjdRWElkbklQVktV?=
 =?utf-8?B?S1ZBK1VWbmtXNHY1RTRNaGNkYWlGK0QxNytrbm9uenlUa1hVZkFsbnBibFpX?=
 =?utf-8?B?eXJ3Kys0a1Y4ZTd2VFBNeFZoRDNMTC8rVGcvNzFTNTB0RjltamxxSjFucVJO?=
 =?utf-8?B?RlNaOHlQekdPLzh5d2MwUVJnRUdPRTQ0b1JtT0wzYkZIMkdIQjdHeTk5Kytp?=
 =?utf-8?B?MDhER0Zrc0xzRVEzQjZWd09maTNIMDlzUGhkNlRESjMyakEvbkp6NEZ1akRS?=
 =?utf-8?B?MXRrNXNDc3A5U1o4MGZreERqbm9IUlJUencrMXFEbTlXNVRrUFRBbm8yanJC?=
 =?utf-8?B?dXIxVjV4L0ZXT1VhYWxjMUZmMkRSWEhWUURKbjN5L25ITnVPemxBVDI2Qml4?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S0IvK3ZPaU9EOGl0bURlRWI4VURRRHhxK2pmaHBmNUR0TW9YajB2NDhsVVIv?=
 =?utf-8?B?Qi9GQ09vSmR6T3QxV2hDVTZkTXh2NFFWejBzYnE0TWFta2k2aHdoa3hCY2hM?=
 =?utf-8?B?aU0xVHRLd1VlaVpQVUJVZjNhMHlFRmJJTU5kV0ZmVXJRTmVhZ0R5OFJ0dERi?=
 =?utf-8?B?T3pQWlRIY1NRK1BLL05jQ3RmempHcWRRamFmcHNDN1hzSjhlRVlNdFFUdmd4?=
 =?utf-8?B?RjhPbDYrazFqOFc5VDZaeUtHM1dqbGFXd1ZUMUZxNWdtZFp3dzQ5N0FXUHdl?=
 =?utf-8?B?MmRUek1ETE55VnlhU0RYaDY4OUorTGhwQlgyNjhvRC9ZS01MUGpjNXBxWEJJ?=
 =?utf-8?B?WDc2ampiYnBDbjJycUlaR0VLOUZOZmM2YzJ2NnFXNEI0ZW5iNHhSOHNTbXZl?=
 =?utf-8?B?c0orQUppRERsajhmenFZWE82S3paUWdzSTlJaHBweWFFR3pyVWdHUGltVUNz?=
 =?utf-8?B?MXRhaEpQVUhxcSt1OG1yT3o3TFFPZ010MXhNQ2pyQm8vcWpvWHJZd1ZhZFAx?=
 =?utf-8?B?U01nSDc2NjJSQkErK29WTVNRMnQ1M0UyTVB4YmhraCtjN1F0Y05EWlhobm9X?=
 =?utf-8?B?T25pVW93OFEvWDNvZ0hoU3UzTnBCbVU5aWQ4YmNROHkraTFpVlpSdkpWdWoy?=
 =?utf-8?B?dzNGSCtGTXlLdS9CQldMV0Evd1hjaXNGWmNmbzQ5VUpCTlRvUVZuTW5DSDhH?=
 =?utf-8?B?aUVYVmdVd1VQT1VFTEVOR2JQNCtFSWpvb0VHa0cranVJVHlVbU9ncXdackFx?=
 =?utf-8?B?dmVkbmlLajNRL1gvVE5kWEpmdEYrbTJUcmlYejd6Nk8wSlJYMFlTNWI5ZkZF?=
 =?utf-8?B?Ukw4dWRSUUU1UHRyV1U0U2FHQzUvQWRaZzU3SjZ2MGRFd3pJSDlhZEd2N25n?=
 =?utf-8?B?YlVrNGovZmdkR21hNUl3ZXdKdTByNzlDUjRQV05qUTV0cExoNzZtSklPR0V2?=
 =?utf-8?B?NFYxd2pkMGNzYWVocmxibnFvMkdFMXBKZ0VQTlVPUG80OFhxamYweWVkUjhr?=
 =?utf-8?B?K0pnK05KcVI4RWZxenVyUWtpandxRmZmekVkOTk5enpEVGRYWk5JbGQ1dGFO?=
 =?utf-8?B?aDFXVzJ5OUJ0SUFIVDZ0ODNVUXpvT3RseXExaXNNZUVQQlF4c2xPb2Y4VHpz?=
 =?utf-8?B?VnRkb2N6ZDNHOHoyYVZ0aW94bCtEMlV5aGRvRnRkaTVSUFlaWlNpMDdlaEl0?=
 =?utf-8?B?ZTNLdDZOSUpZeXlGUUM4cmtBbU15L3JkdG1SQ1NyS2I1T1VzS0NLZGZOUS8r?=
 =?utf-8?B?bVVEcnNsazRrYVhKU0ZyVHRzSFFMdURXOStibjBUbkJwVGJ4TVB3bmlOTCto?=
 =?utf-8?B?MklvdWlDME9pdTZrelRCL3hTN05RSkJ0NE8rUDVneGtaUjJ4NG5iU05zejFp?=
 =?utf-8?B?Ulc2R3FObFpmVSt0YXVHTXZaRHdRVjFXY2Y1TW5uN3dqdm11bGkzcHBHR2wr?=
 =?utf-8?B?L0ZpcG9tV2tpSFY2WTZ3aUJ2a2pWUUVmcWFTMGRIV1RRT0d0R2s3MVNhZWox?=
 =?utf-8?B?ZkhTOWxKenVIdkgyK0NRSk5RdVI1N3hXV3RUY1UxQ2FuVVNEQjVYRDlNUjFr?=
 =?utf-8?B?amxRY3M4VmhKSVE0ODZQZTR4VHFVSmRYemhqYmxZY0lGNzNCbXFvSm5uZ3ZD?=
 =?utf-8?B?R1hQcVFNelJRbHl1TkJvdU51cVcybjVHSjFRUWF3M2FXcUVlVTVMOXBBTnUr?=
 =?utf-8?B?aS9ldS9nRU9hLy9FWXN0SXY1YWd0QzNyV3A4MytBa3YyZFBOdVc5QWE0U3dU?=
 =?utf-8?B?dXNBK3pJeWI1NkFsT3lUTFhBdTNweDdWS0htci9vM0Y0cU4wWm5SMTRpdHFJ?=
 =?utf-8?B?RDlodnZLL0ZpVmM1YlRmWjVDL1FTMUpLcnhmem5NSHVoOGNCYmZoNlRlejYz?=
 =?utf-8?B?UWQ2SzVpbUFzcnUwSGcvNmowMi9CVUVtMVZCd3VDSytkL2xsRXhRdVI3TG5B?=
 =?utf-8?B?am5vcWRkZHErcWtsSXRHK2NrOU5MTFpoUnR1L0Z1QU0wZDUrNUdvQzVrS0hH?=
 =?utf-8?B?RWt2VzAxSFBRMFU1TVMxMTk4YjdPVnk4eHBOdWNjSnRPT3hVL1dPMGZXb0tp?=
 =?utf-8?B?VEdsK2xjSlZ0WXZJc2FqR013NGd4QmVvUk91eDdBNjdiTkowQ1VKdWRrOGV1?=
 =?utf-8?B?eHY1bFYwWkFBKzZoVCtrb0wvVThzelJuUE5EZGNEeDQrUmM1aHMxVmRMZTF5?=
 =?utf-8?B?Vkd4bnZvV25IRzFCRW40T2dJV1VZRm93dFVQeUNRRGxWR1UreDBTY0lsbDNp?=
 =?utf-8?B?V1hydWw0N2RETzlVa1pzZ1lIamRDWTJyT0ZPZ2plK2VQV2xFV2lMUS9WUTgv?=
 =?utf-8?B?d0RYUDVDYWRtdG1IalFwOXBXREtpV2prZWRVUzE0cmFvMkRCWm9BTjFCajBU?=
 =?utf-8?Q?UzR1xYqPBdrBQZhNovX5TL9OUmPW0sifneXHMYmm6u6An?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: xSZn4/7cDjSF23fulfbr1MWT/eogCc1wpZ9eLU6QB8f0VaGTFOofb78TWADucsgyOf7EytA1hydTA7UAWnF84K8jDK7tLMD1aZ9Y2rcuJqc/pcuD34JLrL18noFTB/hUdlvCBwxPtqfoO/xFGFvuVPCzygFQL+74xC7pRq34V5fE6cfZkDKMGLtvTx0GEhTxXuaEZPsgH7GC98d8eoo8rTmelpcttheoxASytgAgyqvt419LIA4+/aFf
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854076b6-54f7-4a99-a36f-08db92ac9d94
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4531.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 16:30:28.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5D/OVhsdlwwe+CTE6zEmnfClfyliRUz0h4sLXYxCtSf8ua/RLvtOdJzeeoVLEsC/V6DOnsVZ4qmGzAj7sqp8AkyS0DW5fzr6s6PgxxgKoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_13,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308010149
X-Proofpoint-ORIG-GUID: eBaUqGEKdg3JLhgrJYLYOtOKB-6WxeFH
X-Proofpoint-GUID: eBaUqGEKdg3JLhgrJYLYOtOKB-6WxeFH
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew,
What is the proper way to submit a small fix to this series? I would like to submit the following as 
cleanup.

I created ARCH_DEFAULT_KEXEC solely for s390 to be able to select it by default per original 
behavior. However, randconfig showed a flaw in this approach and thus s390 solution is now always 
'select KEXEC', thus leaving these couple of bits unused/useless. And I forgot to eliminate these 
bits in the v5/v6 series.

Thanks,
eric

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 42c98931de2c..c9e523e0d997 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -246,9 +246,6 @@ config PGTABLE_LEVELS

  source "kernel/livepatch/Kconfig"

-config ARCH_DEFAULT_KEXEC
-       def_bool y
-
  config ARCH_SUPPORTS_KEXEC
         def_bool y

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index ff72e45cfaef..701cd5336f4f 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -17,7 +17,6 @@ config HAVE_IMA_KEXEC

  config KEXEC
         bool "Enable kexec system call"
-       default ARCH_DEFAULT_KEXEC
         depends on ARCH_SUPPORTS_KEXEC
         select KEXEC_CORE
         help



On 7/12/23 14:15, Andrew Morton wrote:
> 
> The patch titled
>       Subject: kexec: consolidate kexec and crash options into kernel/Kconfig.kexec
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Eric DeVolder <eric.devolder@oracle.com>
> Subject: kexec: consolidate kexec and crash options into kernel/Kconfig.kexec
> Date: Wed, 12 Jul 2023 12:15:32 -0400
> 
> Patch series "refactor Kconfig to consolidate KEXEC and CRASH options", v6.
> 
> The Kconfig is refactored to consolidate KEXEC and CRASH options from
> various arch/<arch>/Kconfig files into new file kernel/Kconfig.kexec.
> 
> The Kconfig.kexec is now a submenu titled "Kexec and crash features"
> located under "General Setup".
> 
> The following options are impacted:
> 
>   - KEXEC
>   - KEXEC_FILE
>   - KEXEC_SIG
>   - KEXEC_SIG_FORCE
>   - KEXEC_IMAGE_VERIFY_SIG
>   - KEXEC_BZIMAGE_VERIFY_SIG
>   - KEXEC_JUMP
>   - CRASH_DUMP
> 
> Over time, these options have been copied between Kconfig files and
> are very similar to one another, but with slight differences.
> 
> The following architectures are impacted by the refactor (because of
> use of one or more KEXEC/CRASH options):
> 
>   - arm
>   - arm64
>   - ia64
>   - loongarch
>   - m68k
>   - mips
>   - parisc
>   - powerpc
>   - riscv
>   - s390
>   - sh
>   - x86
> 
> More information:
> 
> In the patch series "crash: Kernel handling of CPU and memory hot
> un/plug"
> 
>   https://lore.kernel.org/lkml/20230503224145.7405-1-eric.devolder@oracle.com/
> 
> the new kernel feature introduces the config option CRASH_HOTPLUG.
> 
> In reviewing, Thomas Gleixner requested that the new config option
> not be placed in x86 Kconfig. Rather the option needs a generic/common
> home. To Thomas' point, the KEXEC and CRASH options have largely been
> duplicated in the various arch/<arch>/Kconfig files, with minor
> differences. This kind of proliferation is to be avoid/stopped.
> 
>   https://lore.kernel.org/lkml/875y91yv63.ffs@tglx/
> 
> To that end, I have refactored the arch Kconfigs so as to consolidate
> the various KEXEC and CRASH options. Generally speaking, this work has
> the following themes:
> 
> - KEXEC and CRASH options are moved into new file kernel/Kconfig.kexec
>    - These items from arch/Kconfig:
>        CRASH_CORE KEXEC_CORE KEXEC_ELF HAVE_IMA_KEXEC
>    - These items from arch/x86/Kconfig form the common options:
>        KEXEC KEXEC_FILE KEXEC_SIG KEXEC_SIG_FORCE
>        KEXEC_BZIMAGE_VERIFY_SIG KEXEC_JUMP CRASH_DUMP
>    - These items from arch/arm64/Kconfig form the common options:
>        KEXEC_IMAGE_VERIFY_SIG
>    - The crash hotplug series appends CRASH_HOTPLUG to Kconfig.kexec
> - The Kconfig.kexec is now a submenu titled "Kexec and crash features"
>    and is now listed in "General Setup" submenu from init/Kconfig.
> - To control the common options, each has a new ARCH_SUPPORTS_<option>
>    option. These gateway options determine whether the common options
>    options are valid for the architecture.
> - To account for the slight differences in the original architecture
>    coding of the common options, each now has a corresponding
>    ARCH_SELECTS_<option> which are used to elicit the same side effects
>    as the original arch/<arch>/Kconfig files for KEXEC and CRASH options.
> 
> An example, 'make menuconfig' illustrating the submenu:
> 
>    > General setup > Kexec and crash features
>    [*] Enable kexec system call
>    [*] Enable kexec file based system call
>    [*]   Verify kernel signature during kexec_file_load() syscall
>    [ ]     Require a valid signature in kexec_file_load() syscall
>    [ ]     Enable bzImage signature verification support
>    [*] kexec jump
>    [*] kernel crash dumps
>    [*]   Update the crash elfcorehdr on system configuration changes
> 
> In the process of consolidating the common options, I encountered
> slight differences in the coding of these options in several of the
> architectures. As a result, I settled on the following solution:
> 
> - Each of the common options has a 'depends on ARCH_SUPPORTS_<option>'
>    statement. For example, the KEXEC_FILE option has a 'depends on
>    ARCH_SUPPORTS_KEXEC_FILE' statement.
> 
>    This approach is needed on all common options so as to prevent
>    options from appearing for architectures which previously did
>    not allow/enable them. For example, arm supports KEXEC but not
>    KEXEC_FILE. The arch/arm/Kconfig does not provide
>    ARCH_SUPPORTS_KEXEC_FILE and so KEXEC_FILE and related options
>    are not available to arm.
> 
> - The boolean ARCH_SUPPORTS_<option> in effect allows the arch to
>    determine when the feature is allowed.  Archs which don't have the
>    feature simply do not provide the corresponding ARCH_SUPPORTS_<option>.
>    For each arch, where there previously were KEXEC and/or CRASH
>    options, these have been replaced with the corresponding boolean
>    ARCH_SUPPORTS_<option>, and an appropriate def_bool statement.
> 
>    For example, if the arch supports KEXEC_FILE, then the
>    ARCH_SUPPORTS_KEXEC_FILE simply has a 'def_bool y'. This permits
>    the KEXEC_FILE option to be available.
> 
>    If the arch has a 'depends on' statement in its original coding
>    of the option, then that expression becomes part of the def_bool
>    expression. For example, arm64 had:
> 
>    config KEXEC
>      depends on PM_SLEEP_SMP
> 
>    and in this solution, this converts to:
> 
>    config ARCH_SUPPORTS_KEXEC
>      def_bool PM_SLEEP_SMP
> 
> 
> - In order to account for the architecture differences in the
>    coding for the common options, the ARCH_SELECTS_<option> in the
>    arch/<arch>/Kconfig is used. This option has a 'depends on
>    <option>' statement to couple it to the main option, and from
>    there can insert the differences from the common option and the
>    arch original coding of that option.
> 
>    For example, a few archs enable CRYPTO and CRYTPO_SHA256 for
>    KEXEC_FILE. These require a ARCH_SELECTS_KEXEC_FILE and
>    'select CRYPTO' and 'select CRYPTO_SHA256' statements.
> 
> Illustrating the option relationships:
> 
> For each of the common KEXEC and CRASH options:
>   ARCH_SUPPORTS_<option> <- <option> <- ARCH_SELECTS_<option>
> 
>   <option>                   # in Kconfig.kexec
>   ARCH_SUPPORTS_<option>     # in arch/<arch>/Kconfig, as needed
>   ARCH_SELECTS_<option>      # in arch/<arch>/Kconfig, as needed
> 
> 
> For example, KEXEC:
>   ARCH_SUPPORTS_KEXEC <- KEXEC <- ARCH_SELECTS_KEXEC
> 
>   KEXEC                      # in Kconfig.kexec
>   ARCH_SUPPORTS_KEXEC        # in arch/<arch>/Kconfig, as needed
>   ARCH_SELECTS_KEXEC         # in arch/<arch>/Kconfig, as needed
> 
> 
> To summarize, the ARCH_SUPPORTS_<option> permits the <option> to be
> enabled, and the ARCH_SELECTS_<option> handles side effects (ie.
> select statements).
> 
> Examples:
> A few examples to show the new strategy in action:
> 
> ===== x86 (minus the help section) =====
> Original:
>   config KEXEC
>      bool "kexec system call"
>      select KEXEC_CORE
> 
>   config KEXEC_FILE
>      bool "kexec file based system call"
>      select KEXEC_CORE
>      select HAVE_IMA_KEXEC if IMA
>      depends on X86_64
>      depends on CRYPTO=y
>      depends on CRYPTO_SHA256=y
> 
>   config ARCH_HAS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
>   config KEXEC_SIG
>      bool "Verify kernel signature during kexec_file_load() syscall"
>      depends on KEXEC_FILE
> 
>   config KEXEC_SIG_FORCE
>      bool "Require a valid signature in kexec_file_load() syscall"
>      depends on KEXEC_SIG
> 
>   config KEXEC_BZIMAGE_VERIFY_SIG
>      bool "Enable bzImage signature verification support"
>      depends on KEXEC_SIG
>      depends on SIGNED_PE_FILE_VERIFICATION
>      select SYSTEM_TRUSTED_KEYRING
> 
>   config CRASH_DUMP
>      bool "kernel crash dumps"
>      depends on X86_64 || (X86_32 && HIGHMEM)
> 
>   config KEXEC_JUMP
>      bool "kexec jump"
>      depends on KEXEC && HIBERNATION
>      help
> 
> becomes...
> New:
> config ARCH_SUPPORTS_KEXEC
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_FILE
>      def_bool X86_64 && CRYPTO && CRYPTO_SHA256
> 
> config ARCH_SELECTS_KEXEC_FILE
>      def_bool y
>      depends on KEXEC_FILE
>      select HAVE_IMA_KEXEC if IMA
> 
> config ARCH_SUPPORTS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
> config ARCH_SUPPORTS_KEXEC_SIG
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_SIG_FORCE
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_JUMP
>      def_bool y
> 
> config ARCH_SUPPORTS_CRASH_DUMP
>      def_bool X86_64 || (X86_32 && HIGHMEM)
> 
> 
> ===== powerpc (minus the help section) =====
> Original:
>   config KEXEC
>      bool "kexec system call"
>      depends on PPC_BOOK3S || PPC_E500 || (44x && !SMP)
>      select KEXEC_CORE
> 
>   config KEXEC_FILE
>      bool "kexec file based system call"
>      select KEXEC_CORE
>      select HAVE_IMA_KEXEC if IMA
>      select KEXEC_ELF
>      depends on PPC64
>      depends on CRYPTO=y
>      depends on CRYPTO_SHA256=y
> 
>   config ARCH_HAS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
>   config CRASH_DUMP
>      bool "Build a dump capture kernel"
>      depends on PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
>      select RELOCATABLE if PPC64 || 44x || PPC_85xx
> 
> becomes...
> New:
> config ARCH_SUPPORTS_KEXEC
>      def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
> 
> config ARCH_SUPPORTS_KEXEC_FILE
>      def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
> 
> config ARCH_SUPPORTS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
> config ARCH_SELECTS_KEXEC_FILE
>      def_bool y
>      depends on KEXEC_FILE
>      select KEXEC_ELF
>      select HAVE_IMA_KEXEC if IMA
> 
> config ARCH_SUPPORTS_CRASH_DUMP
>      def_bool PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
> 
> config ARCH_SELECTS_CRASH_DUMP
>      def_bool y
>      depends on CRASH_DUMP
>      select RELOCATABLE if PPC64 || 44x || PPC_85xx
> 
> 
> Testing Approach and Results
> 
> There are 388 config files in the arch/<arch>/configs directories.
> For each of these config files, a .config is generated both before and
> after this Kconfig series, and checked for equivalence. This approach
> allows for a rather rapid check of all architectures and a wide
> variety of configs wrt/ KEXEC and CRASH, and avoids requiring
> compiling for all architectures and running kernels and run-time
> testing.
> 
> For each config file, the olddefconfig, allnoconfig and allyesconfig
> targets are utilized. In testing the randconfig has revealed problems
> as well, but is not used in the before and after equivalence check
> since one can not generate the "same" .config for before and after,
> even if using the same KCONFIG_SEED since the option list is
> different.
> 
> As such, the following script steps compare the before and after
> of 'make olddefconfig'. The new symbols introduced by this series
> are filtered out, but otherwise the config files are PASS only if
> they were equivalent, and FAIL otherwise.
> 
> The script performs the test by doing the following:
> 
>   # Obtain the "golden" .config output for given config file
>   # Reset test sandbox
>   git checkout master
>   git branch -D test_Kconfig
>   git checkout -B test_Kconfig master
>   make distclean
>   # Write out updated config
>   cp -f <config file> .config
>   make ARCH=<arch> olddefconfig
>   # Track each item in .config, LHSB is "golden"
>   scoreboard .config
> 
>   # Obtain the "changed" .config output for given config file
>   # Reset test sandbox
>   make distclean
>   # Apply this Kconfig series
>   git am <this Kconfig series>
>   # Write out updated config
>   cp -f <config file> .config
>   make ARCH=<arch> olddefconfig
>   # Track each item in .config, RHSB is "changed"
>   scoreboard .config
> 
>   # Determine test result
>   # Filter-out new symbols introduced by this series
>   # Filter-out symbol=n which not in either scoreboard
>   # Compare LHSB "golden" and RHSB "changed" scoreboards and issue PASS/FAIL
> 
> The script was instrumental during the refactoring of Kconfig as it
> continually revealed problems. The end result being that the solution
> presented in this series passes all configs as checked by the script,
> with the following exceptions:
> 
> - arch/ia64/configs/zx1_config with olddefconfig
>    This config file has:
>    # CONFIG_KEXEC is not set
>    CONFIG_CRASH_DUMP=y
>    and this refactor now couples KEXEC to CRASH_DUMP, so it is not
>    possible to enable CRASH_DUMP without KEXEC.
> 
> - arch/sh/configs/* with allyesconfig
>    The arch/sh/Kconfig codes CRASH_DUMP as dependent upon BROKEN_ON_MMU
>    (which clearly is not meant to be set). This symbol is not provided
>    but with the allyesconfig it is set to yes which enables CRASH_DUMP.
>    But KEXEC is coded as dependent upon MMU, and is set to no in
>    arch/sh/mm/Kconfig, so KEXEC is not enabled.
>    This refactor now couples KEXEC to CRASH_DUMP, so it is not
>    possible to enable CRASH_DUMP without KEXEC.
> 
> While the above exceptions are not equivalent to their original,
> the config file produced is valid (and in fact better wrt/ CRASH_DUMP
> handling).
> 
> 
> This patch (of 14)
> 
> The config options for kexec and crash features are consolidated
> into new file kernel/Kconfig.kexec. Under the "General Setup" submenu
> is a new submenu "Kexec and crash handling". All the kexec and
> crash options that were once in the arch-dependent submenu "Processor
> type and features" are now consolidated in the new submenu.
> 
> The following options are impacted:
> 
>   - KEXEC
>   - KEXEC_FILE
>   - KEXEC_SIG
>   - KEXEC_SIG_FORCE
>   - KEXEC_BZIMAGE_VERIFY_SIG
>   - KEXEC_JUMP
>   - CRASH_DUMP
> 
> The three main options are KEXEC, KEXEC_FILE and CRASH_DUMP.
> 
> Architectures specify support of certain KEXEC and CRASH features with
> similarly named new ARCH_SUPPORTS_<option> config options.
> 
> Architectures can utilize the new ARCH_SELECTS_<option> config
> options to specify additional components when <option> is enabled.
> 
> To summarize, the ARCH_SUPPORTS_<option> permits the <option> to be
> enabled, and the ARCH_SELECTS_<option> handles side effects (ie.
> select statements).
> 
> Link: https://lkml.kernel.org/r/20230712161545.87870-1-eric.devolder@oracle.com
> Link: https://lkml.kernel.org/r/20230712161545.87870-2-eric.devolder@oracle.com
> Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Cc. "H. Peter Anvin" <hpa@zytor.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Dave Hansen <dave.hansen@linux.intel.com> # for x86
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Marc Aurèle La France <tsi@tuyoix.net>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xin Li <xin3.li@intel.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/Kconfig         |   13 ----
>   init/Kconfig         |    2
>   kernel/Kconfig.kexec |  116 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 118 insertions(+), 13 deletions(-)
> 
> --- a/arch/Kconfig~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec
> +++ a/arch/Kconfig
> @@ -11,19 +11,6 @@ source "arch/$(SRCARCH)/Kconfig"
>   
>   menu "General architecture-dependent options"
>   
> -config CRASH_CORE
> -	bool
> -
> -config KEXEC_CORE
> -	select CRASH_CORE
> -	bool
> -
> -config KEXEC_ELF
> -	bool
> -
> -config HAVE_IMA_KEXEC
> -	bool
> -
>   config ARCH_HAS_SUBPAGE_FAULTS
>   	bool
>   	help
> --- a/init/Kconfig~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec
> +++ a/init/Kconfig
> @@ -1927,6 +1927,8 @@ config BINDGEN_VERSION_TEXT
>   config TRACEPOINTS
>   	bool
>   
> +source "kernel/Kconfig.kexec"
> +
>   endmenu		# General setup
>   
>   source "arch/Kconfig"
> --- /dev/null
> +++ a/kernel/Kconfig.kexec
> @@ -0,0 +1,116 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +menu "Kexec and crash features"
> +
> +config CRASH_CORE
> +	bool
> +
> +config KEXEC_CORE
> +	select CRASH_CORE
> +	bool
> +
> +config KEXEC_ELF
> +	bool
> +
> +config HAVE_IMA_KEXEC
> +	bool
> +
> +config KEXEC
> +	bool "Enable kexec system call"
> +	default ARCH_DEFAULT_KEXEC
> +	depends on ARCH_SUPPORTS_KEXEC
> +	select KEXEC_CORE
> +	help
> +	  kexec is a system call that implements the ability to shutdown your
> +	  current kernel, and to start another kernel. It is like a reboot
> +	  but it is independent of the system firmware. And like a reboot
> +	  you can start any kernel with it, not just Linux.
> +
> +	  The name comes from the similarity to the exec system call.
> +
> +	  It is an ongoing process to be certain the hardware in a machine
> +	  is properly shutdown, so do not be surprised if this code does not
> +	  initially work for you. As of this writing the exact hardware
> +	  interface is strongly in flux, so no good recommendation can be
> +	  made.
> +
> +config KEXEC_FILE
> +	bool "Enable kexec file based system call"
> +	depends on ARCH_SUPPORTS_KEXEC_FILE
> +	select KEXEC_CORE
> +	help
> +	  This is new version of kexec system call. This system call is
> +	  file based and takes file descriptors as system call argument
> +	  for kernel and initramfs as opposed to list of segments as
> +	  accepted by kexec system call.
> +
> +config KEXEC_SIG
> +	bool "Verify kernel signature during kexec_file_load() syscall"
> +	depends on ARCH_SUPPORTS_KEXEC_SIG
> +	depends on KEXEC_FILE
> +	help
> +	  This option makes the kexec_file_load() syscall check for a valid
> +	  signature of the kernel image. The image can still be loaded without
> +	  a valid signature unless you also enable KEXEC_SIG_FORCE, though if
> +	  there's a signature that we can check, then it must be valid.
> +
> +	  In addition to this option, you need to enable signature
> +	  verification for the corresponding kernel image type being
> +	  loaded in order for this to work.
> +
> +config KEXEC_SIG_FORCE
> +	bool "Require a valid signature in kexec_file_load() syscall"
> +	depends on ARCH_SUPPORTS_KEXEC_SIG_FORCE
> +	depends on KEXEC_SIG
> +	help
> +	  This option makes kernel signature verification mandatory for
> +	  the kexec_file_load() syscall.
> +
> +config KEXEC_IMAGE_VERIFY_SIG
> +	bool "Enable Image signature verification support (ARM)"
> +	default ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_SIG
> +	depends on ARCH_SUPPORTS_KEXEC_IMAGE_VERIFY_SIG
> +	depends on KEXEC_SIG
> +	depends on EFI && SIGNED_PE_FILE_VERIFICATION
> +	help
> +	  Enable Image signature verification support.
> +
> +config KEXEC_BZIMAGE_VERIFY_SIG
> +	bool "Enable bzImage signature verification support"
> +	depends on ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG
> +	depends on KEXEC_SIG
> +	depends on SIGNED_PE_FILE_VERIFICATION
> +	select SYSTEM_TRUSTED_KEYRING
> +	help
> +	  Enable bzImage signature verification support.
> +
> +config KEXEC_JUMP
> +	bool "kexec jump"
> +	depends on ARCH_SUPPORTS_KEXEC_JUMP
> +	depends on KEXEC && HIBERNATION
> +	help
> +	  Jump between original kernel and kexeced kernel and invoke
> +	  code in physical address mode via KEXEC
> +
> +config CRASH_DUMP
> +	bool "kernel crash dumps"
> +	depends on ARCH_SUPPORTS_CRASH_DUMP
> +	depends on ARCH_SUPPORTS_KEXEC
> +	select CRASH_CORE
> +	select KEXEC_CORE
> +	select KEXEC
> +	help
> +	  Generate crash dump after being started by kexec.
> +	  This should be normally only set in special crash dump kernels
> +	  which are loaded in the main kernel with kexec-tools into
> +	  a specially reserved region and then later executed after
> +	  a crash by kdump/kexec. The crash dump kernel must be compiled
> +	  to a memory address not used by the main kernel or BIOS using
> +	  PHYSICAL_START, or it must be built as a relocatable image
> +	  (CONFIG_RELOCATABLE=y).
> +	  For more details see Documentation/admin-guide/kdump/kdump.rst
> +
> +	  For s390, this option also enables zfcpdump.
> +	  See also <file:Documentation/s390/zfcpdump.rst>
> +
> +endmenu
> _
> 
> Patches currently in -mm which might be from eric.devolder@oracle.com are
> 
> kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
> x86-kexec-refactor-for-kernel-kconfigkexec.patch
> arm-kexec-refactor-for-kernel-kconfigkexec.patch
> ia64-kexec-refactor-for-kernel-kconfigkexec.patch
> arm64-kexec-refactor-for-kernel-kconfigkexec.patch
> loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
> m68k-kexec-refactor-for-kernel-kconfigkexec.patch
> mips-kexec-refactor-for-kernel-kconfigkexec.patch
> parisc-kexec-refactor-for-kernel-kconfigkexec.patch
> powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
> riscv-kexec-refactor-for-kernel-kconfigkexec.patch
> s390-kexec-refactor-for-kernel-kconfigkexec.patch
> sh-kexec-refactor-for-kernel-kconfigkexec.patch
> kexec-rename-arch_has_kexec_purgatory.patch
> 
